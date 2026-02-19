#!/usr/bin/env bash
# Capture a full AA session from both sides (phone + Pi head unit)
#
# This captures raw TCP traffic on both sides simultaneously so we can
# decode AAP frames with full context. Captures happen pre-TLS for the
# initial handshake and post-TLS for everything else.
#
# Prerequisites:
#   - Phone connected via USB with root access
#   - Pi head unit accessible via SSH (default: matt@192.168.1.149)
#   - tcpdump installed on both devices
#
# Usage:
#   ./capture_aa_session.sh                    # default settings
#   ./capture_aa_session.sh --pi-only          # only capture on Pi
#   ./capture_aa_session.sh --phone-only       # only capture on phone
#   PI_HOST=10.0.0.1 ./capture_aa_session.sh   # custom Pi address

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output/captures"
mkdir -p "$OUTPUT_DIR"

# Configuration
PI_HOST="${PI_HOST:-192.168.1.149}"
PI_USER="${PI_USER:-matt}"
PI_AA_PORT="${PI_AA_PORT:-5277}"      # AA TCP port on Pi
PHONE_IFACE="${PHONE_IFACE:-wlan0}"   # Phone WiFi interface
PI_IFACE="${PI_IFACE:-wlan0}"         # Pi AP interface
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

CAPTURE_PHONE=true
CAPTURE_PI=true

# Parse args
for arg in "$@"; do
    case "$arg" in
        --pi-only) CAPTURE_PHONE=false ;;
        --phone-only) CAPTURE_PI=false ;;
        --help) echo "Usage: $0 [--pi-only|--phone-only]"; exit 0 ;;
    esac
done

echo "=== AA Session Capture ==="
echo "Timestamp: $TIMESTAMP"
echo "Pi host:   $PI_HOST"
echo ""

PIDS=()

cleanup() {
    echo ""
    echo "Stopping captures..."
    for pid in "${PIDS[@]}"; do
        kill "$pid" 2>/dev/null || true
    done
    # Stop remote captures
    if $CAPTURE_PI; then
        ssh "$PI_USER@$PI_HOST" "sudo pkill -f 'tcpdump.*aa_capture' 2>/dev/null || true" 2>/dev/null || true
    fi
    if $CAPTURE_PHONE; then
        adb shell "su -c 'pkill -f tcpdump'" 2>/dev/null || true
    fi

    echo ""
    echo "=== Captures saved ==="
    ls -la "$OUTPUT_DIR"/*"$TIMESTAMP"* 2>/dev/null || echo "No capture files found."

    echo ""
    echo "Decode with:"
    echo "  python3 decode_aap_frames.py $OUTPUT_DIR/pi_capture_$TIMESTAMP.pcap"
    echo "  python3 decode_aap_frames.py $OUTPUT_DIR/phone_capture_$TIMESTAMP.pcap"
}
trap cleanup EXIT

# Start Pi-side capture
if $CAPTURE_PI; then
    echo "Starting Pi-side capture (SSH to $PI_HOST)..."
    PI_PCAP="/tmp/aa_capture_$TIMESTAMP.pcap"
    LOCAL_PI_PCAP="$OUTPUT_DIR/pi_capture_$TIMESTAMP.pcap"

    ssh "$PI_USER@$PI_HOST" "sudo tcpdump -i $PI_IFACE -w $PI_PCAP port $PI_AA_PORT 2>/dev/null &" &
    PIDS+=($!)
    echo "  Pi capture started -> $PI_PCAP"
fi

# Start phone-side capture
if $CAPTURE_PHONE; then
    echo "Starting phone-side capture (via ADB)..."
    PHONE_PCAP="/data/local/tmp/aa_capture_$TIMESTAMP.pcap"
    LOCAL_PHONE_PCAP="$OUTPUT_DIR/phone_capture_$TIMESTAMP.pcap"

    adb shell "su -c 'tcpdump -i $PHONE_IFACE -w $PHONE_PCAP port $PI_AA_PORT 2>/dev/null &'" &
    PIDS+=($!)
    echo "  Phone capture started -> $PHONE_PCAP"
fi

echo ""
echo "Captures running. Connect AA to the head unit now."
echo "Press Ctrl+C to stop capture and download files."
echo ""

# Wait for interrupt
while true; do
    sleep 1
done

# Note: cleanup trap handles stopping captures.
# After cleanup, pull files:
if $CAPTURE_PI; then
    echo "Pulling Pi capture..."
    scp "$PI_USER@$PI_HOST:$PI_PCAP" "$LOCAL_PI_PCAP" 2>/dev/null || echo "  Failed to pull Pi capture."
    ssh "$PI_USER@$PI_HOST" "rm -f $PI_PCAP" 2>/dev/null || true
fi
if $CAPTURE_PHONE; then
    echo "Pulling phone capture..."
    adb pull "$PHONE_PCAP" "$LOCAL_PHONE_PCAP" 2>/dev/null || echo "  Failed to pull phone capture."
    adb shell "su -c 'rm -f $PHONE_PCAP'" 2>/dev/null || true
fi
