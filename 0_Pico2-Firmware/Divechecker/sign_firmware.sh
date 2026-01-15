#!/bin/bash
# ============================================================================
# Signed Firmware Update Script for DiveChecker
# ============================================================================
#
# This script creates signed firmware images for secure OTA updates.
# 
# Security Model:
# - Firmware is signed with ECDSA P-256 private key
# - Device verifies signature before applying update
# - Same key pair used for device authentication
#
# Usage:
#   ./sign_firmware.sh <firmware.uf2>
#
# Output:
#   firmware_signed.bin - Signed firmware image
#
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Security: Verify we're in the right directory
if [[ ! "$SCRIPT_DIR" == *"0_Pico2-Firmware/Divechecker"* ]]; then
    echo "❌ ERROR: Script must be run from Divechecker firmware directory"
    exit 1
fi

KEYS_DIR="$SCRIPT_DIR/keys"
PRIVATE_KEY_PEM="$KEYS_DIR/divechecker_private.pem"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <firmware.uf2>"
    exit 1
fi

FIRMWARE="$1"

# Handle relative paths
if [[ ! "$FIRMWARE" = /* ]]; then
    FIRMWARE="$(pwd)/$FIRMWARE"
fi

OUTPUT_DIR="$(dirname "$FIRMWARE")"
FIRMWARE_NAME="$(basename "$FIRMWARE" .uf2)"
SIGNED_OUTPUT="$OUTPUT_DIR/${FIRMWARE_NAME}_signed.bin"
SIG_OUTPUT="$OUTPUT_DIR/${FIRMWARE_NAME}.sig"

echo "=== DiveChecker Firmware Signing Tool ==="
echo ""

# Check prerequisites
if [ ! -f "$FIRMWARE" ]; then
    echo "❌ ERROR: Firmware file not found: $FIRMWARE"
    exit 1
fi

if [ ! -f "$PRIVATE_KEY_PEM" ]; then
    echo "❌ ERROR: Private key not found: $PRIVATE_KEY_PEM"
    echo "   Run generate_keys.sh first, or use OTP-programmed key."
    exit 1
fi

# Get firmware info (Linux compatible)
FW_SIZE=$(stat -c%s "$FIRMWARE" 2>/dev/null || stat -f%z "$FIRMWARE")
FW_HASH=$(sha256sum "$FIRMWARE" | cut -d' ' -f1)

echo "📄 Firmware: $FIRMWARE"
echo "   Size: $FW_SIZE bytes"
echo "   SHA256: $FW_HASH"
echo ""

# Sign the firmware directly (not the hash of the hash)
echo "🔐 Signing firmware..."
openssl dgst -sha256 -sign "$PRIVATE_KEY_PEM" -out "$SIG_OUTPUT" "$FIRMWARE"

SIG_SIZE=$(stat -c%s "$SIG_OUTPUT" 2>/dev/null || stat -f%z "$SIG_OUTPUT")
SIG_HEX=$(xxd -p "$SIG_OUTPUT" | tr -d '\n')

echo "   Signature size: $SIG_SIZE bytes"
echo "   Signature: ${SIG_HEX:0:32}..."
echo ""

# Create signed firmware package
# Format: [4-byte magic][4-byte fw_size][4-byte sig_size][signature][firmware]
echo "📦 Creating signed firmware package..."

# Use printf for binary output (more portable)
{
    # Magic: "DC01" as bytes (0x44 0x43 0x30 0x31)
    printf '\x44\x43\x30\x31'
    # Firmware size (little-endian 32-bit)
    printf "\\x$(printf '%02x' $((FW_SIZE & 0xFF)))"
    printf "\\x$(printf '%02x' $(((FW_SIZE >> 8) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((FW_SIZE >> 16) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((FW_SIZE >> 24) & 0xFF)))"
    # Signature size (little-endian 32-bit)
    printf "\\x$(printf '%02x' $((SIG_SIZE & 0xFF)))"
    printf "\\x$(printf '%02x' $(((SIG_SIZE >> 8) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((SIG_SIZE >> 16) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((SIG_SIZE >> 24) & 0xFF)))"
    # Signature
    cat "$SIG_OUTPUT"
    # Firmware
    cat "$FIRMWARE"
} > "$SIGNED_OUTPUT"

TOTAL_SIZE=$(stat -c%s "$SIGNED_OUTPUT" 2>/dev/null || stat -f%z "$SIGNED_OUTPUT")

echo ""
echo "✅ Signed firmware package created!"
echo ""
echo "📦 Output files:"
echo "   1. $SIGNED_OUTPUT"
echo "      → 앱에서 서명 검증용 (${TOTAL_SIZE} bytes)"
echo "   2. $FIRMWARE"
echo "      → BOOTSEL 모드에서 플래싱용 (원본 .uf2)"
echo "   3. $SIG_OUTPUT"
echo "      → 서명 파일 (${SIG_SIZE} bytes)"
echo ""
echo "📋 사용 방법:"
echo "   1. 앱에서 _signed.bin 파일로 서명 검증"
echo "   2. BOOTSEL 모드 진입 후 원본 .uf2 파일을 RPI-RP2에 복사"
echo ""
echo "📋 CLI 검증 명령:"
echo "   openssl dgst -sha256 -verify $KEYS_DIR/divechecker_public.pem -signature $SIG_OUTPUT $FIRMWARE"
echo ""

# Verify signature
echo "🔍 Verifying signature..."
if openssl dgst -sha256 -verify "$KEYS_DIR/divechecker_public.pem" -signature "$SIG_OUTPUT" "$FIRMWARE" 2>/dev/null; then
    echo "   ✅ Signature valid!"
else
    echo "   ❌ Signature verification FAILED!"
    exit 1
fi
