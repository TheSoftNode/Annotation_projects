#!/bin/bash

echo "=== R1 Step 9: Verify the 'undefined awk variables are empty' claim ==="
echo ""

echo "Testing undefined variable:"
awk 'BEGIN { print "<" missing_var ">", missing_var + 0 }'

echo ""
echo "Expected: empty string between < >, and 0 for numeric context"
