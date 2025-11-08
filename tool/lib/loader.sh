#!/bin/bash
# ==========================================
# loader.sh — resolves correct library path
# ==========================================

# Resolve this script's true path (even if symlinked)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

# Detect library location
LIB_DIR_SYSTEM="/usr/local/lib/tool"
LIB_DIR_LOCAL="$SCRIPT_DIR"
LIB_DIR_DEV="$(cd "$SCRIPT_DIR/.." && pwd)/lib"

if [ -d "$LIB_DIR_SYSTEM" ]; then
    LIB_DIR="$LIB_DIR_SYSTEM"
elif [ -d "$LIB_DIR_DEV" ]; then
    LIB_DIR="$LIB_DIR_DEV"
else
    echo "❌ Error: Could not locate tool libraries."
    echo "Searched in:"
    echo "  - $LIB_DIR_SYSTEM"
    echo "  - $LIB_DIR_DEV"
    exit 1
fi

# Export LIB_DIR so sub-scripts can use it
export LIB_DIR

# Source required libraries
if [ -f "$LIB_DIR/logger.sh" ]; then
    source "$LIB_DIR/logger.sh"
else
    echo "❌ Missing logger.sh in $LIB_DIR"
    exit 1
fi

[ -f "$LIB_DIR/utils.sh" ] && source "$LIB_DIR/utils.sh"

