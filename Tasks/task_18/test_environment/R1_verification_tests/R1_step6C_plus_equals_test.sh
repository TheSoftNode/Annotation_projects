#!/bin/bash

echo "=== R1 Step 6C: Verify the += claim directly ==="
echo ""

echo "Testing += operator:"
echo "awk 'BEGIN { s=\"abc\"; s+=\"def\"; print s }'"
awk 'BEGIN { s="abc"; s+="def"; print s }'

echo ""
echo "Testing string concatenation:"
echo "awk 'BEGIN { s=\"abc\"; s=s \"def\"; print s }'"
awk 'BEGIN { s="abc"; s=s "def"; print s }'

echo ""
echo "If += were string concatenation, both should print 'abcdef'"
echo "If += is arithmetic, first will convert to numbers and print '0'"
