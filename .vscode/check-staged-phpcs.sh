#!/bin/bash
# Check staged files with PHPCS

WORKSPACE_FOLDER="$(dirname "$(dirname "$(readlink -f "$0")")")"

# Get staged files
FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\.(php|phtml|js|less|css)$' 2>/dev/null || true)

if [ -z "$FILES" ]; then
    echo "✓ No staged PHP/PHTML/JS/LESS/CSS files to check"
    exit 0
fi

echo "Checking staged files:"
echo "$FILES"
echo "---"

# Run PHPCS on the files
echo "$FILES" | xargs "${WORKSPACE_FOLDER}/vendor/bin/phpcs" --standard=Magento2 -s

if [ $? -eq 0 ]; then
    echo "---"
    echo "✓ All staged files passed PHPCS checks"
else
    echo "---"
    echo "✗ PHPCS found issues in staged files"
    exit 1
fi