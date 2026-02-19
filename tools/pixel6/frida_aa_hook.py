#!/usr/bin/env python3
"""
Frida wrapper for Android Auto protocol interception.

Launches/attaches to the AA app on a connected Pixel 6 and runs the
frida_aa_hook.js script. Captures all output to a log file with timestamps.

Usage:
    python3 frida_aa_hook.py              # Attach to running AA
    python3 frida_aa_hook.py --spawn      # Launch AA fresh
    python3 frida_aa_hook.py --discover   # Just discover AA classes, then exit
"""

import argparse
import datetime
import os
import signal
import sys
import time
from pathlib import Path

try:
    import frida
except ImportError:
    print("ERROR: frida not installed. Run: pip install frida-tools")
    sys.exit(1)

SCRIPT_DIR = Path(__file__).parent
HOOK_JS = SCRIPT_DIR / "frida_aa_hook.js"
OUTPUT_DIR = SCRIPT_DIR / "output" / "captures"
AA_PACKAGE = "com.google.android.projection.gearhead"


def on_message(message, data):
    """Handle messages from the Frida script."""
    ts = datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]

    if message["type"] == "send":
        payload = message.get("payload", "")
        print(f"[{ts}] {payload}")
        if log_file:
            log_file.write(f"[{ts}] {payload}\n")
            log_file.flush()
    elif message["type"] == "error":
        desc = message.get("description", str(message))
        print(f"[{ts}] ERROR: {desc}", file=sys.stderr)
        if log_file:
            log_file.write(f"[{ts}] ERROR: {desc}\n")
            log_file.flush()
    else:
        print(f"[{ts}] {message}")


def on_console_message(level, text):
    """Handle console.log output from the Frida script."""
    ts = datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]
    print(f"[{ts}] {text}")
    if log_file:
        log_file.write(f"[{ts}] {text}\n")
        log_file.flush()


log_file = None


def main():
    global log_file

    parser = argparse.ArgumentParser(description="Frida AA protocol interceptor")
    parser.add_argument("--spawn", action="store_true", help="Spawn AA app (vs attach to running)")
    parser.add_argument("--discover", action="store_true", help="Discover AA classes and exit")
    parser.add_argument("--no-log", action="store_true", help="Don't write log file")
    parser.add_argument("--device", type=str, help="Frida device ID (default: first USB)")
    args = parser.parse_args()

    # Setup log file
    if not args.no_log:
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        log_name = f"frida_aa_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        log_path = OUTPUT_DIR / log_name
        log_file = open(log_path, "w")
        print(f"Logging to: {log_path}")

    # Load hook script
    if not HOOK_JS.exists():
        print(f"ERROR: Hook script not found: {HOOK_JS}")
        sys.exit(1)
    script_source = HOOK_JS.read_text()

    # Connect to device
    print("Connecting to device...")
    try:
        if args.device:
            device = frida.get_device(args.device)
        else:
            device = frida.get_usb_device(timeout=5)
    except frida.TimedOutError:
        print("ERROR: No USB device found. Check that:")
        print("  1. Phone is connected via USB")
        print("  2. USB debugging is enabled")
        print("  3. frida-server is running (./push-frida-server.sh)")
        sys.exit(1)

    print(f"Device: {device.name}")

    # Attach or spawn
    if args.spawn:
        print(f"Spawning {AA_PACKAGE}...")
        pid = device.spawn([AA_PACKAGE])
        session = device.attach(pid)
        print(f"Attached to PID {pid}")
    else:
        print(f"Attaching to {AA_PACKAGE}...")
        try:
            session = device.attach(AA_PACKAGE)
        except frida.ProcessNotFoundError:
            print(f"ERROR: {AA_PACKAGE} not running. Use --spawn or open AA manually.")
            sys.exit(1)

    # Create and load script
    script = session.create_script(script_source)
    script.on("message", on_message)
    script.load()

    if args.spawn:
        device.resume(pid)
        print("Process resumed.")

    if args.discover:
        print("\nRunning class discovery...")
        script.exports_sync.discover()
        time.sleep(3)
        print("\nDone.")
        session.detach()
        return

    # Run until interrupted
    print("\nHooks active. Connect to a head unit to capture AA messages.")
    print("Press Ctrl+C to stop and print statistics.\n")

    def signal_handler(sig, frame):
        print("\n\nStopping...")
        try:
            script.exports_sync.stats()
        except Exception:
            pass
        time.sleep(0.5)
        session.detach()
        if log_file:
            log_file.close()
            print(f"Log saved to: {log_path}")
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    # Keep alive
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        signal_handler(None, None)


if __name__ == "__main__":
    main()
