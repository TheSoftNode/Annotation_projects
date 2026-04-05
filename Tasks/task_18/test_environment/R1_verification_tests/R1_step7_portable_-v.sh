#!/bin/bash

echo "=== R1 Step 7: Verify the portable -v claim ==="
echo ""

echo "Testing -v with default awk:"
awk -v x=hello 'BEGIN { print x }'

echo ""
echo "Testing -v with mawk (if available):"
mawk -v x=hello 'BEGIN { print x }' 2>/dev/null || echo "mawk not available"

echo ""
echo "Testing -v with busybox awk (if available):"
busybox awk -v x=hello 'BEGIN { print x }' 2>/dev/null || echo "busybox not available"

echo ""
echo "Testing -v with gawk (if available):"
gawk -v x=hello 'BEGIN { print x }' 2>/dev/null || echo "gawk not available"
