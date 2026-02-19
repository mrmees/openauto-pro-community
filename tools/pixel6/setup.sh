#!/usr/bin/env bash
# Setup dependencies for AA protocol extraction from rooted Pixel 6
# Run once on claude-dev VM before connecting the phone
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== AA Protocol Extraction — Dependency Setup ==="
echo ""

# --- System packages ---
echo "[1/4] Installing system packages (adb, protobuf compiler)..."
PKGS=()
command -v adb    >/dev/null 2>&1 || PKGS+=(android-tools-adb)
command -v protoc >/dev/null 2>&1 || PKGS+=(protobuf-compiler)
command -v unzip  >/dev/null 2>&1 || PKGS+=(unzip)
command -v jq     >/dev/null 2>&1 || PKGS+=(jq)

if [ ${#PKGS[@]} -gt 0 ]; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq "${PKGS[@]}"
else
    echo "  All system packages already installed."
fi

# --- Python packages ---
echo "[2/4] Installing Python packages..."
pip install --quiet --upgrade \
    protobuf \
    frida-tools \
    lief \
    construct

# Verify frida can find its server version
FRIDA_VERSION=$(frida --version 2>/dev/null || echo "unknown")
echo "  Frida version: $FRIDA_VERSION"

# --- Frida server for Android ---
echo "[3/4] Downloading Frida server for Android ARM64..."
FRIDA_SERVER_DIR="$SCRIPT_DIR/frida-server"
mkdir -p "$FRIDA_SERVER_DIR"

if [ ! -f "$FRIDA_SERVER_DIR/frida-server" ]; then
    if [ "$FRIDA_VERSION" = "unknown" ]; then
        echo "  ERROR: frida-tools not installed properly, can't determine version."
        echo "  Install manually: pip install frida-tools"
        exit 1
    fi

    FRIDA_URL="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/frida-server-${FRIDA_VERSION}-android-arm64.xz"
    echo "  Downloading from: $FRIDA_URL"
    curl -sL "$FRIDA_URL" -o "$FRIDA_SERVER_DIR/frida-server.xz"
    xz -d "$FRIDA_SERVER_DIR/frida-server.xz"
    chmod +x "$FRIDA_SERVER_DIR/frida-server"
    echo "  Frida server ready at: $FRIDA_SERVER_DIR/frida-server"
else
    echo "  Frida server already downloaded."
fi

# --- Output directory ---
echo "[4/4] Creating output directories..."
mkdir -p "$SCRIPT_DIR/output"/{apk,libs,protos,captures,decoded}

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Connect Pixel 6 via USB and enable USB debugging"
echo "  2. Run: adb devices   (verify phone shows up)"
echo "  3. Run: ./push-frida-server.sh   (push & start frida-server on phone)"
echo "  4. Run: ./pull-aa-apk.sh   (pull Android Auto APK)"
echo "  5. Run: python3 extract_aa_protos.py   (extract proto descriptors)"
echo ""
echo "For live capture:"
echo "  6. Run: python3 frida_aa_hook.py   (hook AA app protobuf layer)"
echo "  7. Run: ./capture_aa_session.sh   (dual-side packet capture)"
echo "  8. Run: python3 decode_aap_frames.py <capture.pcap>   (decode frames)"
