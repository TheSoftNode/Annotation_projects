#!/bin/bash

echo "=== R1 Step 8: Verify the GNU-awk-specific --assign claim ==="
echo ""

if ! command -v gawk &> /dev/null; then
    echo "gawk is not installed. Skipping this test."
    echo "Install with: brew install gawk (macOS) or sudo apt-get install gawk (Linux)"
    exit 0
fi

echo "GNU Awk version:"
gawk --version | head -n 1

echo ""
echo "Testing --assign with gawk:"
gawk --assign x=hello 'BEGIN { print x }'
