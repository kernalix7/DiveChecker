#!/bin/bash
# ECDSA Key Generation Script for DiveChecker
# Generates P-256 (secp256r1) key pair

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KEYS_DIR="$SCRIPT_DIR/keys"

# Security: Verify we're in the right directory
if [[ ! "$SCRIPT_DIR" == *"0_Pico2-Firmware/Divechecker"* ]]; then
    echo "❌ ERROR: Script must be run from Divechecker firmware directory"
    exit 1
fi

mkdir -p "$KEYS_DIR"

PRIVATE_KEY="$KEYS_DIR/divechecker_private.pem"
PUBLIC_KEY="$KEYS_DIR/divechecker_public.pem"
HEADER_FILE="$KEYS_DIR/ecdsa_private_keys.h"

echo "=== DiveChecker ECDSA Key Generator ==="

# Check if keys already exist
if [ -f "$PRIVATE_KEY" ]; then
    echo "⚠️  Keys already exist!"
    read -p "Overwrite? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

# Generate private key (P-256 / secp256r1)
echo "Generating P-256 private key..."
openssl ecparam -name prime256v1 -genkey -noout -out "$PRIVATE_KEY"

# Extract public key
echo "Extracting public key..."
openssl ec -in "$PRIVATE_KEY" -pubout -out "$PUBLIC_KEY"

# Extract raw private key bytes (32 bytes) - handle leading zeros properly
# Method: Use openssl asn1parse for reliable extraction
PRIVATE_HEX=$(openssl ec -in "$PRIVATE_KEY" -text -noout 2>/dev/null | \
    sed -n '/priv:/,/pub:/p' | \
    grep -v 'priv:\|pub:' | \
    tr -d ' \n\t' | \
    sed 's/://g')
# Ensure exactly 64 hex chars (32 bytes) - pad with leading zeros if needed
PRIVATE_HEX=$(echo "$PRIVATE_HEX" | tr -d '\n')
PRIVATE_LEN=${#PRIVATE_HEX}
if [ "$PRIVATE_LEN" -lt 64 ]; then
    # Pad with leading zeros
    PADDING=$(printf '%0*d' $((64 - PRIVATE_LEN)) 0)
    PRIVATE_HEX="${PADDING}${PRIVATE_HEX}"
elif [ "$PRIVATE_LEN" -gt 64 ]; then
    # Remove leading zeros (sometimes openssl adds 00 prefix)
    PRIVATE_HEX=$(echo "$PRIVATE_HEX" | sed 's/^0*//')
    PRIVATE_HEX=$(printf '%064s' "$PRIVATE_HEX" | tr ' ' '0')
fi

# Validate private key length
if [ ${#PRIVATE_HEX} -ne 64 ]; then
    echo "❌ ERROR: Private key extraction failed (got ${#PRIVATE_HEX} chars, expected 64)"
    exit 1
fi

# Extract raw public key bytes (uncompressed: 04 + X(32) + Y(32) = 65 bytes)
PUBLIC_HEX=$(openssl ec -in "$PRIVATE_KEY" -text -noout 2>/dev/null | \
    sed -n '/pub:/,/ASN1 OID/p' | \
    grep -v 'pub:\|ASN1' | \
    tr -d ' \n\t' | \
    sed 's/://g')
# Ensure exactly 130 hex chars (65 bytes)
PUBLIC_HEX=$(echo "$PUBLIC_HEX" | tr -d '\n')
PUBLIC_LEN=${#PUBLIC_HEX}
if [ "$PUBLIC_LEN" -lt 130 ]; then
    echo "⚠️  WARNING: Public key shorter than expected ($PUBLIC_LEN chars)"
fi

# Validate public key (should start with 04 for uncompressed)
if [ "${PUBLIC_HEX:0:2}" != "04" ]; then
    echo "❌ ERROR: Public key not in uncompressed format (missing 04 prefix)"
    exit 1
fi

# Validate public key length
if [ ${#PUBLIC_HEX} -ne 130 ]; then
    echo "❌ ERROR: Public key extraction failed (got ${#PUBLIC_HEX} chars, expected 130)"
    exit 1
fi

echo "✓ Private key: ${#PRIVATE_HEX} hex chars (32 bytes)"
echo "✓ Public key: ${#PUBLIC_HEX} hex chars (65 bytes, starts with 04)"

# Generate C header file for MCU (private key)
echo "Generating C header for MCU..."
cat > "$HEADER_FILE" << 'HEADER_START'
/**
 * ECDSA Keys for DiveChecker Device Authentication
 * 
 * ⚠️  WARNING: This file contains the PRIVATE KEY!
 *     - DO NOT commit to git
 *     - For production: store in OTP with read protection
 * 
 * Algorithm: ECDSA P-256 (secp256r1)
 * Generated: TIMESTAMP
 */

#ifndef ECDSA_KEYS_H
#define ECDSA_KEYS_H

#include <stdint.h>

// Private key (32 bytes) - KEEP SECRET!
static const uint8_t ECDSA_PRIVATE_KEY[32] = {
HEADER_START

# Replace timestamp (works on both Linux and macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/TIMESTAMP/$(date '+%Y-%m-%d %H:%M:%S')/" "$HEADER_FILE"
else
    sed -i "s/TIMESTAMP/$(date '+%Y-%m-%d %H:%M:%S')/" "$HEADER_FILE"
fi

# Format private key as C array
echo -n "    " >> "$HEADER_FILE"
PRIV_FORMATTED=""
for ((i=0; i<64; i+=2)); do
    byte="${PRIVATE_HEX:$i:2}"
    if [ -n "$byte" ]; then
        PRIV_FORMATTED+="0x$byte, "
    fi
done
echo "${PRIV_FORMATTED%, }" >> "$HEADER_FILE"

cat >> "$HEADER_FILE" << 'HEADER_MID'
};

// Public key (uncompressed: 04 || X || Y = 65 bytes)
static const uint8_t ECDSA_PUBLIC_KEY[65] = {
HEADER_MID

# Format public key as C array (65 bytes: 04 + 32 + 32)
echo -n "    " >> "$HEADER_FILE"
PUB_FORMATTED=""
count=0
for ((i=0; i<130; i+=2)); do
    byte="${PUBLIC_HEX:$i:2}"
    if [ -n "$byte" ]; then
        PUB_FORMATTED+="0x$byte, "
        count=$((count + 1))
        if [ $((count % 12)) -eq 0 ]; then
            PUB_FORMATTED+="\n    "
        fi
    fi
done
echo -e "${PUB_FORMATTED%, }" >> "$HEADER_FILE"

cat >> "$HEADER_FILE" << 'HEADER_END'
};

#endif // ECDSA_KEYS_H
HEADER_END

# Generate Dart file for Flutter app (public key only)
DART_FILE="$KEYS_DIR/ecdsa_public_key.dart"
echo "Generating Dart file for Flutter app..."
cat > "$DART_FILE" << DART_START
/// ECDSA Public Key for DiveChecker Device Authentication
/// 
/// Algorithm: ECDSA P-256 (secp256r1)
/// Generated: $(date '+%Y-%m-%d %H:%M:%S')
/// 
/// This file contains ONLY the public key - safe to include in app.

import 'dart:typed_data';

/// Public key (uncompressed: 04 || X || Y = 65 bytes)
final Uint8List ecdsaPublicKey = Uint8List.fromList([
DART_START

# Format public key for Dart
PUB_DART=""
count=0
for ((i=0; i<130; i+=2)); do
    byte="${PUBLIC_HEX:$i:2}"
    if [ -n "$byte" ]; then
        PUB_DART+="0x$byte, "
        count=$((count + 1))
        if [ $((count % 12)) -eq 0 ]; then
            PUB_DART+="\n  "
        fi
    fi
done
echo "  ${PUB_DART%, }" >> "$DART_FILE"

cat >> "$DART_FILE" << 'DART_END'
]);
DART_END

# ============================================================================
# Auto-deploy keys to project locations
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLUTTER_APP_DIR="$SCRIPT_DIR/../../_0_DiveChecker-APP"
FIRMWARE_DIR="$SCRIPT_DIR"

FIRMWARE_KEY_FILE="$FIRMWARE_DIR/ecdsa_private_keys.h"
FLUTTER_SECURITY_DIR="$FLUTTER_APP_DIR/lib/security"
FLUTTER_KEY_FILE="$FLUTTER_SECURITY_DIR/ecdsa_public_key.dart"

echo ""
echo "🚀 Auto-deploying keys..."

# Check for existing files
EXISTING_FILES=""
if [ -f "$FIRMWARE_KEY_FILE" ]; then
    EXISTING_FILES="$EXISTING_FILES\n  - $FIRMWARE_KEY_FILE"
fi
if [ -f "$FLUTTER_KEY_FILE" ]; then
    EXISTING_FILES="$EXISTING_FILES\n  - $FLUTTER_KEY_FILE"
fi

if [ -n "$EXISTING_FILES" ]; then
    echo ""
    echo -e "⚠️  The following files already exist:$EXISTING_FILES"
    read -p "Overwrite deployed keys? (y/N): " deploy_confirm
    if [ "$deploy_confirm" != "y" ] && [ "$deploy_confirm" != "Y" ]; then
        echo "Skipping auto-deploy. Keys are in $KEYS_DIR/"
        echo ""
        echo "Manual copy commands:"
        echo "  cp $HEADER_FILE $FIRMWARE_KEY_FILE"
        echo "  cp $DART_FILE $FLUTTER_KEY_FILE"
        exit 0
    fi
fi

# Deploy to firmware (MCU)
if [ -d "$FIRMWARE_DIR" ]; then
    cp "$HEADER_FILE" "$FIRMWARE_KEY_FILE"
    echo "  ✓ Copied to firmware: $FIRMWARE_KEY_FILE"
else
    echo "  ⚠️  Firmware dir not found: $FIRMWARE_DIR"
fi

# Deploy to Flutter app
if [ -d "$FLUTTER_APP_DIR" ]; then
    mkdir -p "$FLUTTER_SECURITY_DIR"
    cp "$DART_FILE" "$FLUTTER_KEY_FILE"
    echo "  ✓ Copied to Flutter: $FLUTTER_KEY_FILE"
else
    echo "  ⚠️  Flutter app dir not found: $FLUTTER_APP_DIR"
fi

echo ""
echo "✅ Keys generated and deployed!"
echo ""
echo "Files created:"
echo "  📁 $KEYS_DIR/"
echo "  🔐 divechecker_private.pem (KEEP SECRET!)"
echo "  🔓 divechecker_public.pem"
echo "  📄 ecdsa_private_keys.h (for MCU - contains private key)"
echo "  📄 ecdsa_public_key.dart (for Flutter app - public key only)"
echo ""
echo "Auto-deployed to:"
echo "  📦 Firmware: ./ecdsa_private_keys.h"
echo "  📱 Flutter:  $FLUTTER_SECURITY_DIR/ecdsa_public_key.dart"
echo ""
echo "⚠️  CRITICAL SECURITY RULES:"
echo "  1. NEVER commit keys/ directory to git"
echo "  2. NEVER commit ecdsa_private_keys.h to git"
echo "  3. For production: program private key to OTP, then DELETE from filesystem"
echo ""
echo "🔒 Verify gitignore is working:"
echo "  git status  # Should NOT show any key files"
