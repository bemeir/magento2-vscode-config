#!/bin/bash
# Fix LESS file formatting after Prettier runs on save
# This script only fixes what Prettier doesn't handle: decimal formatting and vendor prefix ordering

FILE="$1"
SCRIPT_DIR="$(dirname "$0")"
FILE_HASH="$(echo "$FILE" | md5sum | cut -d' ' -f1)"
GUARD_FILE="/tmp/fix-less-guard-${FILE_HASH}"

# Prevent multiple concurrent runs
if [ -f "$GUARD_FILE" ]; then
    GUARD_AGE=$(($(date +%s) - $(stat -c %Y "$GUARD_FILE" 2>/dev/null || echo 0)))
    if [ $GUARD_AGE -lt 3 ]; then
        exit 0
    fi
    rm -f "$GUARD_FILE"
fi

touch "$GUARD_FILE"
trap "rm -f $GUARD_FILE" EXIT

# Small delay to ensure Prettier has completed
sleep 0.5

# Fix decimal formatting (remove leading zeros)
sed -i 's/: 0\.\([0-9]\)/: .\1/g; s/ 0\.\([0-9]\)/ .\1/g; s/(0\.\([0-9]\)/(.\1/g; s/, 0\.\([0-9]\)/, .\1/g' "$FILE"

# Fix property ordering (vendor prefixes) using Python script
python3 "$SCRIPT_DIR/fix-less-order.py" "$FILE"

# DO NOT run stylelint --fix as it incorrectly sorts vendor prefixes