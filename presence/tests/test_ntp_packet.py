"""Tests du module SNTP du Pico W (exécutables sous CPython : python -m unittest)."""
import os
import struct
import sys
import time
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "pico_w_timesync"))

import ntp_packet as n  # noqa: E402

D = n.NTP_DELTA_1970


class NtpPacketTest(unittest.TestCase):
    def test_roundtrip_ns(self):
        ns = 1_234_567_890_123_456_789
        back = n.ntp_to_ns(n.ns_to_ntp(ns, D), D)
        self.assertLess(abs(back - ns), 2)  # précision 2^-32 s

    def test_request_is_48_bytes_client_mode(self):
        req = n.build_request(time.time_ns(), D)
        self.assertEqual(len(req), 48)
        self.assertEqual(req[0] & 0x07, 3)

    def test_response_echoes_originate_and_sets_server_mode(self):
        t1 = time.time_ns()
        req = n.build_request(t1, D)
        rx = time.time_ns()
        resp = n.build_response(req, rx, time.time_ns(), D)
        self.assertEqual(len(resp), 48)
        self.assertEqual(resp[0], 0x24)  # LI=0, VN=4, mode=4
        self.assertEqual(resp[1], 2)  # stratum 2
        self.assertEqual(resp[24:32], req[40:48])  # originate = transmit du client
        t3 = n.parse_transmit_ns(resp, D)
        self.assertLess(abs(t3 - t1), 50_000_000)

    def test_ignores_non_client_packets(self):
        req = bytearray(n.build_request(time.time_ns(), D))
        req[0] = (req[0] & ~0x07) | 4  # mode serveur
        self.assertIsNone(n.build_response(bytes(req), 0, 0, D))

    def test_ignores_short_packets(self):
        self.assertIsNone(n.build_response(b"\x23" * 10, 0, 0, D))

    def test_fraction_resolution(self):
        ts = n.ns_to_ntp(500_000_000, D)  # 0,5 s
        self.assertEqual(ts & 0xFFFFFFFF, 1 << 31)

    def test_layout_matches_rfc4330(self):
        resp = n.build_response(n.build_request(0, D), 0, 0, D)
        li_vn_mode, stratum, poll, precision = struct.unpack("!BBbb", resp[:4])
        self.assertEqual((li_vn_mode >> 3) & 0x07, 4)  # version 4
        self.assertEqual(precision, -20)
        self.assertEqual(resp[12:16], b"PICO")


if __name__ == "__main__":
    unittest.main()
