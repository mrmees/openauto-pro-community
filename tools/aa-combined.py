#!/usr/bin/env python3
"""
Combined AA service: HFP AG + HSP + AA RFCOMM with proper protobuf encoding.
SDP handled by sdp_clean (legacy C).
"""
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
import struct
import socket
import os
import subprocess
import sys

AA_UUID = "4de17a00-52cb-11e6-bdf4-0800200c9a66"
HSP_HS_UUID = "00001108-0000-1000-8000-00805f9b34fb"
HFP_AG_UUID = "0000111f-0000-1000-8000-00805f9b34fb"
RFCOMM_CHANNEL = 8


def encode_varint(value):
    """Encode an integer as a protobuf varint."""
    parts = []
    while value > 0x7f:
        parts.append((value & 0x7f) | 0x80)
        value >>= 7
    parts.append(value & 0x7f)
    return bytes(parts)


def encode_string_field(field_num, value):
    """Encode a protobuf string field (wire type 2 = length-delimited)."""
    tag = (field_num << 3) | 2
    data = value if isinstance(value, bytes) else value.encode()
    return encode_varint(tag) + encode_varint(len(data)) + data


def encode_varint_field(field_num, value):
    """Encode a protobuf varint field (wire type 0)."""
    tag = (field_num << 3) | 0
    return encode_varint(tag) + encode_varint(value)


def build_wifi_start_request(ip_addr, port):
    """Build WifiStartRequest protobuf.
    message WifiStartRequest {
        required string ip_address = 1;
        required uint32 port = 2;
    }
    """
    return encode_string_field(1, ip_addr) + encode_varint_field(2, port)


def build_wifi_info_response(ssid, key, bssid, security_mode=8, ap_type=1):
    """Build WifiInfoResponse protobuf.
    message WifiInfoResponse {
        required string ssid = 1;
        required string key = 2;
        required string bssid = 3;
        required SecurityMode security_mode = 4;  // WPA2_PERSONAL = 8
        required AccessPointType access_point_type = 5;  // DYNAMIC = 1
    }
    """
    return (
        encode_string_field(1, ssid) +
        encode_string_field(2, key) +
        encode_string_field(3, bssid) +
        encode_varint_field(4, security_mode) +
        encode_varint_field(5, ap_type)
    )


def send_message(sock, msg_id, payload):
    """Send a framed message: [length:u16be][msg_id:u16be][payload]"""
    header = struct.pack(">HH", len(payload), msg_id)
    sock.sendall(header + payload)


class DummyProfile(dbus.service.Object):
    def __init__(self, bus, path, name):
        super().__init__(bus, path)
        self.name = name
        self._fd = None

    @dbus.service.method("org.bluez.Profile1",
                         in_signature="oha{sv}", out_signature="")
    def NewConnection(self, device, fd, properties):
        fd = fd.take()
        print(f"[{self.name}] NewConnection from {device}, fd={fd}", flush=True)
        self._fd = fd  # Keep fd open

    @dbus.service.method("org.bluez.Profile1", in_signature="o", out_signature="")
    def RequestDisconnection(self, device):
        print(f"[{self.name}] Disconnect: {device}", flush=True)
        if self._fd is not None:
            try:
                os.close(self._fd)
            except:
                pass
            self._fd = None

    @dbus.service.method("org.bluez.Profile1", in_signature="", out_signature="")
    def Release(self):
        print(f"[{self.name}] Released", flush=True)


class AAProfile(dbus.service.Object):
    @dbus.service.method("org.bluez.Profile1",
                         in_signature="oha{sv}", out_signature="")
    def NewConnection(self, device, fd, properties):
        fd = fd.take()
        print(f"[AA] NewConnection from {device}, fd={fd}", flush=True)

        sock = socket.fromfd(fd, socket.AF_BLUETOOTH, socket.SOCK_STREAM)
        os.close(fd)
        sock.setblocking(True)
        sock.settimeout(10.0)

        try:
            # Stage 1: Send WifiStartRequest (msgId=1)
            payload = build_wifi_start_request("10.0.0.1", 5288)
            send_message(sock, 1, payload)
            print(f"[AA] Sent WifiStartRequest (ip=10.0.0.1, port=5288)", flush=True)
            print(f"[AA]   payload hex: {payload.hex()}", flush=True)

            # Read messages in a loop
            for stage in range(5):
                try:
                    resp_header = sock.recv(4)
                    if len(resp_header) < 4:
                        print(f"[AA] Short header ({len(resp_header)} bytes)", flush=True)
                        break
                    resp_len, resp_id = struct.unpack(">HH", resp_header)
                    print(f"[AA] Received msgId={resp_id}, length={resp_len}", flush=True)

                    resp_body = b""
                    if resp_len > 0:
                        resp_body = sock.recv(resp_len)
                        print(f"[AA]   body: {resp_body.hex()}", flush=True)

                    if resp_id == 2:
                        # WifiInfoRequest — send WifiInfoResponse
                        mac_out = subprocess.check_output(["ip", "link", "show", "wlan0"]).decode()
                        mac = ""
                        for line in mac_out.split("\n"):
                            if "ether" in line:
                                mac = line.strip().split()[1].upper()
                                break

                        payload = build_wifi_info_response(
                            ssid="OpenAutoProdigy",
                            key="prodigy1",
                            bssid=mac,  # e.g. "DC:A6:32:E7:5A:FE"
                            security_mode=8,  # WPA2_PERSONAL
                            ap_type=1,  # DYNAMIC
                        )
                        send_message(sock, 3, payload)
                        print(f"[AA] Sent WifiInfoResponse (ssid=OpenAutoProdigy, bssid={mac})", flush=True)
                        print(f"[AA]   payload hex: {payload.hex()}", flush=True)

                    elif resp_id == 6:
                        print("[AA] Got WifiConnectStatus — handshake complete!", flush=True)
                        break

                    elif resp_id == 7:
                        print("[AA] Got WifiStartResponse", flush=True)

                except socket.timeout:
                    print(f"[AA] Timeout waiting for message (stage {stage})", flush=True)
                    break

            print("[AA] RFCOMM handshake done", flush=True)
        except Exception as e:
            print(f"[AA] Error: {e}", flush=True)
        finally:
            sock.close()

    @dbus.service.method("org.bluez.Profile1", in_signature="o", out_signature="")
    def RequestDisconnection(self, device):
        print(f"[AA] Disconnect: {device}", flush=True)

    @dbus.service.method("org.bluez.Profile1", in_signature="", out_signature="")
    def Release(self):
        print("[AA] Released", flush=True)


def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    manager = dbus.Interface(
        bus.get_object("org.bluez", "/org/bluez"),
        "org.bluez.ProfileManager1"
    )

    # HFP AG — REQUIRED by Android Auto
    hfp_profile = DummyProfile(bus, "/org/openauto/hfp_profile", "HFP-AG")
    hfp_opts = {
        "Role": dbus.String("server"),
        "RequireAuthentication": dbus.Boolean(False),
        "RequireAuthorization": dbus.Boolean(False),
        "Name": dbus.String("Hands-Free Audio Gateway"),
    }
    try:
        manager.RegisterProfile("/org/openauto/hfp_profile", HFP_AG_UUID, hfp_opts)
        print(f"[*] HFP AG profile registered", flush=True)
    except dbus.exceptions.DBusException as e:
        print(f"[!] HFP AG failed: {e}", flush=True)

    # HSP HS — additional compatibility
    hsp_profile = DummyProfile(bus, "/org/openauto/hsp_profile", "HSP")
    hsp_opts = {
        "Role": dbus.String("server"),
        "RequireAuthentication": dbus.Boolean(False),
        "RequireAuthorization": dbus.Boolean(False),
        "Name": dbus.String("HSP HS"),
    }
    try:
        manager.RegisterProfile("/org/openauto/hsp_profile", HSP_HS_UUID, hsp_opts)
        print(f"[*] HSP HS profile registered", flush=True)
    except dbus.exceptions.DBusException as e:
        print(f"[!] HSP failed: {e}", flush=True)

    # AA RFCOMM
    aa_profile = AAProfile(bus, "/org/openauto/aa_profile")
    aa_opts = {
        "Role": dbus.String("server"),
        "Channel": dbus.UInt16(RFCOMM_CHANNEL),
        "RequireAuthentication": dbus.Boolean(False),
        "RequireAuthorization": dbus.Boolean(False),
        "AutoConnect": dbus.Boolean(True),
        "Name": dbus.String("Android Auto Wireless"),
    }
    try:
        manager.RegisterProfile("/org/openauto/aa_profile", AA_UUID, aa_opts)
        print(f"[*] AA profile registered (channel={RFCOMM_CHANNEL})", flush=True)
    except dbus.exceptions.DBusException as e:
        print(f"[!] AA failed: {e}", flush=True)
        sys.exit(1)

    print("[*] Ready. Waiting for phone...", flush=True)
    loop = GLib.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
