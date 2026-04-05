#!/bin/bash

echo "=== R2 Step 4: Isolate the += claim ==="
echo ""

echo "Testing += as string concatenation (R2's assumption):"
echo "awk 'BEGIN { s=\"abc\"; s+=\"def\"; print s }'"
awk 'BEGIN { s="abc"; s+="def"; print s }'

echo ""
echo "Testing actual string concatenation in awk:"
echo "awk 'BEGIN { s=\"abc\"; s=s \"def\"; print s }'"
awk 'BEGIN { s="abc"; s=s "def"; print s }'

echo ""
echo "CRITICAL: If += were string concatenation, both would print 'abcdef'"
echo "But += is actually arithmetic assignment in awk!"
