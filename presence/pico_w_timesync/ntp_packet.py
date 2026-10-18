"""Paquets NTP/SNTP minimaux (sans dépendance, testable sous CPython et MicroPython)."""
import struct

# Secondes entre 1900-01-01 (époque NTP) et l'époque de l'horloge locale.
# MicroPython (rp2) : 2000-01-01 -> 3155673600 ; CPython (Unix) : 1970-01-01 -> 2208988800.
NTP_DELTA_2000 = 3155673600
NTP_DELTA_1970 = 2208988800

_FMT = "!BBbbII4sQ8sQQ"  # 48 octets


def ns_to_ntp(ns, delta):
    """Nanosecondes depuis l'époque locale -> timestamp NTP 64 bits (32.32)."""
    secs = ns // 1_000_000_000 + delta
    frac = ((ns % 1_000_000_000) << 32) // 1_000_000_000
    return (secs << 32) | frac


def ntp_to_ns(ts, delta):
    """Timestamp NTP 64 bits -> nanosecondes depuis l'époque locale."""
    secs = (ts >> 32) - delta
    frac = ts & 0xFFFFFFFF
    return secs * 1_000_000_000 + (frac * 1_000_000_000 >> 32)


def build_request(now_ns, delta):
    """Requête client (mode 3, v4) ; transmit timestamp = now_ns."""
    return struct.pack(
        _FMT, 0x23, 0, 0, 0, 0, 0, b"\0\0\0\0", 0, b"\0" * 8, 0, ns_to_ntp(now_ns, delta)
    )


def parse_transmit_ns(packet, delta):
    """Transmit timestamp (octets 40-47) d'une réponse, en ns locales."""
    return ntp_to_ns(struct.unpack("!Q", packet[40:48])[0], delta)


def build_response(request, rx_ns, tx_ns, delta, stratum=2, ref_ns=None):
    """Réponse serveur (mode 4). Le champ 'originate' recopie le transmit du client."""
    if len(request) < 48:
        return None
    mode = request[0] & 0x07
    if mode != 3:  # on ne répond qu'aux clients
        return None
    orig = request[40:48]
    ref = ns_to_ntp(ref_ns if ref_ns is not None else rx_ns, delta)
    return struct.pack(
        _FMT,
        (0 << 6) | (4 << 3) | 4,  # LI=0, VN=4, mode=4 (serveur)
        stratum,
        request[2],               # poll recopié
        -20,                      # précision ~1 µs
        0,
        0,
        b"PICO",
        ref,
        orig,
        ns_to_ntp(rx_ns, delta),
        ns_to_ntp(tx_ns, delta),
    )
