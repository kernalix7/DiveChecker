#!/bin/bash
# ============================================================================
# Common functions for DiveChecker scripts
# ============================================================================
# Source this file in other scripts:
#   source "$(dirname "$0")/scripts_common.sh"
# ============================================================================

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export CYAN='\033[0;36m'
export NC='\033[0m'

# Find picotool in common locations
find_picotool() {
    local PICOTOOL_CMD=""
    
    if command -v picotool &> /dev/null; then
        PICOTOOL_CMD="picotool"
    elif [ -f "$HOME/.pico-sdk/picotool/2.2.0-a4/picotool/picotool" ]; then
        PICOTOOL_CMD="$HOME/.pico-sdk/picotool/2.2.0-a4/picotool/picotool"
    elif [ -f "$HOME/.pico-sdk/picotool/2.2.0/picotool/picotool" ]; then
        PICOTOOL_CMD="$HOME/.pico-sdk/picotool/2.2.0/picotool/picotool"
    else
        local PICOTOOL_FOUND=$(find "$HOME/.pico-sdk" -name "picotool" -type f -executable 2>/dev/null | head -1)
        if [ -n "$PICOTOOL_FOUND" ]; then
            PICOTOOL_CMD="$PICOTOOL_FOUND"
        fi
    fi
    
    echo "$PICOTOOL_CMD"
}

# Verify script is running from correct directory
verify_script_dir() {
    local script_dir="$1"
    if [[ ! "$script_dir" == *"0_Pico2-Firmware/Divechecker"* ]]; then
        echo -e "${RED}❌ ERROR: Script must be run from Divechecker firmware directory${NC}"
        exit 1
    fi
}

# Check if file is within allowed directory (security)
verify_file_in_dir() {
    local file_path="$1"
    local allowed_dir="$2"
    
    local file_realpath=$(realpath "$file_path" 2>/dev/null || echo "")
    local dir_realpath=$(realpath "$allowed_dir" 2>/dev/null || echo "")
    
    if [[ ! "$file_realpath" == "$dir_realpath"* ]]; then
        echo -e "${RED}❌ ERROR: File must be within allowed directory${NC}"
        echo "   Allowed: $dir_realpath"
        echo "   File: $file_realpath"
        return 1
    fi
    return 0
}

# Get file size (cross-platform)
get_file_size() {
    local file="$1"
    stat -c%s "$file" 2>/dev/null || stat -f%z "$file"
}

# Print success message
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Print error message
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Print info message
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}
