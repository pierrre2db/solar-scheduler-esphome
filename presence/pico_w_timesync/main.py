"""Pico W : serveur de temps SNTP local pour les nœuds radar ESPHome.

- Se cale sur un serveur NTP amont (précision ~ms, sous-seconde, contrairement à ntptime.settime()).
- Sert ensuite ce temps en UDP/123 : les ESP32 pointent `time.sntp.servers` dessus.
- Horloge entre deux calages = ticks_us (dérive négligeable sur 1 min).

Fichiers à copier sur le Pico W : main.py, ntp_packet.py, secrets.py (voir secrets.py.example).
"""
import network
import socket
import time

import ntp_packet as ntp
from secrets import WIFI_SSID, WIFI_PASSWORD

UPSTREAM = "pool.ntp.org"
RESYNC_S = 60
D = ntp.NTP_DELTA_2000  # MicroPython rp2 : époque 2000

_ref_ns = 0      # temps UTC (ns, époque 2000) au dernier calage
_ref_ticks = 0   # time.ticks_us() au dernier calage
_synced = False


def now_ns():
    return _ref_ns + time.ticks_diff(time.ticks_us(), _ref_ticks) * 1000


def wifi_connect():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.config(pm=network.WLAN.PM_NONE)  # pas d'économie d'énergie : latence minimale
    wlan.connect(WIFI_SSID, WIFI_PASSWORD)
    for _ in range(60):
        if wlan.isconnected():
            print("WiFi OK", wlan.ifconfig())
            return wlan
        time.sleep(0.5)
    raise RuntimeError("WiFi KO")


def sync_upstream():
    """Calage SNTP complet (t1..t4) : offset = ((t2-t1)+(t3-t4))/2."""
    global _ref_ns, _ref_ticks, _synced
    addr = socket.getaddrinfo(UPSTREAM, 123)[0][-1]
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(2)
    try:
        t1_ticks = time.ticks_us()
        # Premier calage : on ne connaît pas encore l'heure -> timestamp 0 accepté par les serveurs.
        s.sendto(ntp.build_request(now_ns() if _synced else 0, D), addr)
        data = s.recv(48)
        t4_ticks = time.ticks_us()
    finally:
        s.close()
    t3 = ntp.parse_transmit_ns(data, D)
    rtt_us = time.ticks_diff(t4_ticks, t1_ticks)
    # t3 + rtt/2 ~ heure serveur à l'arrivée ; on ancre sur t4.
    _ref_ns = t3 + (rtt_us // 2) * 1000
    _ref_ticks = t4_ticks
    _synced = True
    print("sync ok, rtt=%d us" % rtt_us)


def serve():
    srv = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    srv.bind(("0.0.0.0", 123))
    srv.settimeout(1)
    last_sync = time.ticks_ms()
    while True:
        if time.ticks_diff(time.ticks_ms(), last_sync) > RESYNC_S * 1000:
            try:
                sync_upstream()
                last_sync = time.ticks_ms()
            except OSError as e:
                print("sync KO", e)
                last_sync = time.ticks_add(time.ticks_ms(), -(RESYNC_S - 10) * 1000)  # retry dans 10 s
        try:
            req, client = srv.recvfrom(128)
        except OSError:  # timeout
            continue
        # ne jamais servir une heure non calée ou périmée (ticks_diff est fiable ~9 min max)
        if not _synced or time.ticks_diff(time.ticks_us(), _ref_ticks) > 300_000_000:
            continue
        rx = now_ns()
        resp = ntp.build_response(req, rx, now_ns(), D, ref_ns=_ref_ns)
        if resp:
            srv.sendto(resp, client)


wifi_connect()
while not _synced:
    try:
        sync_upstream()
    except OSError as e:
        print("sync KO", e)
        time.sleep(2)
serve()
