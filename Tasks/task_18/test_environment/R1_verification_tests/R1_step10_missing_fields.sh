#!/bin/bash

echo "=== R1 Step 10: Verify the '\$9 is empty if NF < 9' claim ==="
echo ""

echo "Testing with only 3 fields:"
printf '%s\n' 'cpu 42 5' | awk '{ print "NF=" NF, "9th=<" $9 ">" }'

echo ""
echo "Expected: NF=3, 9th=<>"
