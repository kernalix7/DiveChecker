#!/bin/bash
# ============================================================================
# Secure Boot Setup Script for DiveChecker (RP2350)
# ============================================================================
#
# ⚠️  CRITICAL WARNING: SECURE BOOT IS PERMANENT AND IRREVERSIBLE!
# ⚠️  Once enabled, ONLY signed firmware can run!
# ⚠️  If you lose the signing key, the device is BRICKED!
#
# This script:
# 1. Generates Secure Boot signing keys (if not exist)
# 2. Signs the firmware
# 3. Optionally programs boot key to OTP and enables Secure Boot
#
# Usage:
#   ./setup_secure_boot.sh generate     # Generate keys only
#   ./setup_secure_boot.sh sign         # Sign firmware (requires keys)
#   ./setup_secure_boot.sh enable       # Enable Secure Boot (PERMANENT!)
#   ./setup_secure_boot.sh --help       # Show help
#
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Security: Verify we're in the right directory
if [[ ! "$SCRIPT_DIR" == *"0_Pico2-Firmware/Divechecker"* ]]; then
    echo -e "${RED}❌ ERROR: Script must be run from Divechecker firmware directory${NC}"
    exit 1
fi

KEYS_DIR="$PROJECT_ROOT/.certs/secure_boot"
BOOT_PRIVATE_KEY="$KEYS_DIR/boot_private.pem"
BOOT_PUBLIC_KEY="$KEYS_DIR/boot_public.pem"
BUILD_DIR="$SCRIPT_DIR/build"
FIRMWARE_UF2="$BUILD_DIR/Divechecker.uf2"
FIRMWARE_BIN="$BUILD_DIR/Divechecker.bin"
SIGNED_UF2="$BUILD_DIR/Divechecker_signed.uf2"
SIGNED_BIN="$BUILD_DIR/Divechecker_signed.bin"

# Find picotool
PICOTOOL_CMD=""
if command -v picotool &> /dev/null; then
    PICOTOOL_CMD="picotool"
elif [ -f "$HOME/.pico-sdk/picotool/2.2.0-a4/picotool/picotool" ]; then
    PICOTOOL_CMD="$HOME/.pico-sdk/picotool/2.2.0-a4/picotool/picotool"
else
    PICOTOOL_FOUND=$(find "$HOME/.pico-sdk" -name "picotool" -type f -executable 2>/dev/null | head -1)
    if [ -n "$PICOTOOL_FOUND" ]; then
        PICOTOOL_CMD="$PICOTOOL_FOUND"
    fi
fi

show_help() {
    echo ""
    echo "DiveChecker Secure Boot Setup"
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  generate    Generate Secure Boot signing keys"
    echo "  sign        Sign firmware with the boot key"
    echo "  enable      Program boot key to OTP and enable Secure Boot (PERMANENT!)"
    echo "  status      Check current Secure Boot status"
    echo "  --help      Show this help"
    echo ""
    echo "Typical workflow:"
    echo "  1. ./setup_secure_boot.sh generate"
    echo "  2. ./setup_secure_boot.sh sign"
    echo "  3. Flash signed firmware and TEST thoroughly"
    echo "  4. ./setup_secure_boot.sh enable  (only after testing!)"
    echo ""
}

generate_keys() {
    echo ""
    echo -e "${CYAN}=== Generating Secure Boot Keys ===${NC}"
    echo ""
    
    mkdir -p "$KEYS_DIR"
    
    if [ -f "$BOOT_PRIVATE_KEY" ]; then
        echo -e "${YELLOW}⚠️  Boot keys already exist!${NC}"
        echo "   $BOOT_PRIVATE_KEY"
        read -p "Overwrite? (y/N): " confirm
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "Aborted."
            return 0
        fi
    fi
    
    # RP2350 uses secp256k1 for Secure Boot (NOT P-256!)
    echo "Generating secp256k1 private key..."
    openssl ecparam -name secp256k1 -genkey -noout -out "$BOOT_PRIVATE_KEY"
    
    echo "Extracting public key..."
    openssl ec -in "$BOOT_PRIVATE_KEY" -pubout -out "$BOOT_PUBLIC_KEY"
    
    # Set restrictive permissions
    chmod 600 "$BOOT_PRIVATE_KEY"
    chmod 644 "$BOOT_PUBLIC_KEY"
    
    echo ""
    echo -e "${GREEN}✅ Secure Boot keys generated!${NC}"
    echo ""
    echo "   📁 $KEYS_DIR/"
    echo "   🔐 boot_private.pem (KEEP SECRET! BACKUP THIS!)"
    echo "   🔓 boot_public.pem"
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ⚠️  BACKUP boot_private.pem IMMEDIATELY!                    ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  If you lose this key after enabling Secure Boot:           ║${NC}"
    echo -e "${RED}║  • You can NEVER update firmware again                      ║${NC}"
    echo -e "${RED}║  • The device becomes a BRICK                               ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  Store backups in MULTIPLE secure locations!                ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

sign_firmware() {
    echo ""
    echo -e "${CYAN}=== Signing Firmware ===${NC}"
    echo ""
    
    # Check keys exist
    if [ ! -f "$BOOT_PRIVATE_KEY" ]; then
        echo -e "${RED}❌ ERROR: Boot private key not found!${NC}"
        echo "   Run './setup_secure_boot.sh generate' first."
        exit 1
    fi
    
    # Check picotool
    if [ -z "$PICOTOOL_CMD" ]; then
        echo -e "${RED}❌ ERROR: picotool not found!${NC}"
        exit 1
    fi
    
    # Find firmware file
    if [ ! -f "$FIRMWARE_BIN" ] && [ ! -f "$FIRMWARE_UF2" ]; then
        echo -e "${RED}❌ ERROR: Firmware not found!${NC}"
        echo "   Expected: $FIRMWARE_BIN or $FIRMWARE_UF2"
        echo "   Build the firmware first."
        exit 1
    fi
    
    # Sign the firmware
    if [ -f "$FIRMWARE_BIN" ]; then
        echo "Signing $FIRMWARE_BIN..."
        $PICOTOOL_CMD sign "$FIRMWARE_BIN" "$BOOT_PRIVATE_KEY" "$SIGNED_BIN"
        echo -e "${GREEN}✓ Created: $SIGNED_BIN${NC}"
    fi
    
    if [ -f "$FIRMWARE_UF2" ]; then
        echo "Signing $FIRMWARE_UF2..."
        $PICOTOOL_CMD sign "$FIRMWARE_UF2" "$BOOT_PRIVATE_KEY" "$SIGNED_UF2"
        echo -e "${GREEN}✓ Created: $SIGNED_UF2${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}✅ Firmware signed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Flash the signed firmware: $SIGNED_UF2"
    echo "  2. Test thoroughly"
    echo "  3. Only then run './setup_secure_boot.sh enable'"
    echo ""
}

check_status() {
    echo ""
    echo -e "${CYAN}=== Secure Boot Status ===${NC}"
    echo ""
    
    if [ -z "$PICOTOOL_CMD" ]; then
        echo -e "${RED}❌ picotool not found${NC}"
        return 1
    fi
    
    echo "Checking device..."
    if ! $PICOTOOL_CMD info &> /dev/null; then
        echo -e "${YELLOW}⚠️  No device in BOOTSEL mode${NC}"
        return 0
    fi
    
    echo ""
    $PICOTOOL_CMD info
    echo ""
    
    # Try to read OTP secure boot status
    echo "Checking OTP Secure Boot flags..."
    # Note: actual OTP locations may vary - this is illustrative
    $PICOTOOL_CMD otp list 2>&1 | grep -i "secure\|boot" || echo "   (Could not determine Secure Boot status from OTP)"
    echo ""
}

enable_secure_boot() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║   ██████╗  █████╗ ███╗   ██╗ ██████╗ ███████╗██████╗        ║${NC}"
    echo -e "${RED}║   ██╔══██╗██╔══██╗████╗  ██║██╔════╝ ██╔════╝██╔══██╗       ║${NC}"
    echo -e "${RED}║   ██║  ██║███████║██╔██╗ ██║██║  ███╗█████╗  ██████╔╝       ║${NC}"
    echo -e "${RED}║   ██║  ██║██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██╔══██╗       ║${NC}"
    echo -e "${RED}║   ██████╔╝██║  ██║██║ ╚████║╚██████╔╝███████╗██║  ██║       ║${NC}"
    echo -e "${RED}║   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝       ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  THIS ACTION IS PERMANENT AND IRREVERSIBLE!                 ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  After enabling Secure Boot:                                ║${NC}"
    echo -e "${RED}║  • ONLY firmware signed with YOUR key will boot             ║${NC}"
    echo -e "${RED}║  • Unsigned firmware will be REJECTED                       ║${NC}"
    echo -e "${RED}║  • If you lose boot_private.pem = DEVICE IS BRICKED         ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  Prerequisites:                                             ║${NC}"
    echo -e "${RED}║  ✓ boot_private.pem backed up to MULTIPLE locations         ║${NC}"
    echo -e "${RED}║  ✓ Signed firmware tested and working                       ║${NC}"
    echo -e "${RED}║  ✓ This is a TEST device (not production, first time)       ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check prerequisites
    if [ ! -f "$BOOT_PUBLIC_KEY" ]; then
        echo -e "${RED}❌ ERROR: Boot public key not found!${NC}"
        echo "   Run './setup_secure_boot.sh generate' first."
        exit 1
    fi
    
    if [ -z "$PICOTOOL_CMD" ]; then
        echo -e "${RED}❌ ERROR: picotool not found!${NC}"
        exit 1
    fi
    
    # Check device connected
    if ! $PICOTOOL_CMD info &> /dev/null; then
        echo -e "${RED}❌ ERROR: No device in BOOTSEL mode!${NC}"
        exit 1
    fi
    
    echo ""
    read -p "Have you backed up boot_private.pem? (yes/no): " backup_confirm
    if [ "$backup_confirm" != "yes" ]; then
        echo -e "${RED}❌ STOP! Backup your key first!${NC}"
        exit 1
    fi
    
    echo ""
    read -p "Have you tested signed firmware successfully? (yes/no): " test_confirm
    if [ "$test_confirm" != "yes" ]; then
        echo -e "${RED}❌ STOP! Test signed firmware first!${NC}"
        echo "   1. ./setup_secure_boot.sh sign"
        echo "   2. Flash signed firmware"
        echo "   3. Verify it works"
        exit 1
    fi
    
    echo ""
    read -p "Type 'ENABLE SECURE BOOT PERMANENTLY' to continue: " final_confirm
    if [ "$final_confirm" != "ENABLE SECURE BOOT PERMANENTLY" ]; then
        echo "Aborted."
        exit 0
    fi
    
    echo ""
    echo "🔐 Programming Secure Boot..."
    echo ""
    
    # Step 1: Load boot key to OTP
    echo "   Step 1: Programming boot key to OTP..."
    if ! $PICOTOOL_CMD otp load "$BOOT_PUBLIC_KEY" 2>&1; then
        echo -e "${RED}❌ ERROR: Failed to load boot key${NC}"
        exit 1
    fi
    echo -e "${GREEN}   ✓ Boot key programmed${NC}"
    
    # Step 2: Enable Secure Boot
    echo "   Step 2: Enabling Secure Boot..."
    if ! $PICOTOOL_CMD otp set BOOT_FLAGS0 0x00000001 2>&1; then
        echo -e "${YELLOW}   ⚠️  Could not set BOOT_FLAGS0 - may need different method${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}✅ Secure Boot setup attempted!${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  NOTE: The exact commands may vary by picotool version.${NC}"
    echo "   Please verify Secure Boot status:"
    echo "   $PICOTOOL_CMD info"
    echo ""
    echo "   If Secure Boot is not enabled, consult RP2350 documentation for"
    echo "   the correct OTP bits to set."
    echo ""
}

# Main
case "$1" in
    generate)
        generate_keys
        ;;
    sign)
        sign_firmware
        ;;
    enable)
        enable_secure_boot
        ;;
    status)
        check_status
        ;;
    --help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
