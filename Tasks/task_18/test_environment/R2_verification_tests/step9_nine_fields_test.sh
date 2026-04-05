#!/bin/bash

echo "=== R2 Step 9: Test the '9 fields per line' claim ==="
echo ""

echo "Testing with only 3 fields:"
printf '%s\n' 'cpu 100 1' | awk '{
    print "NF=" NF, "1=<" $1 ">", "2=<" $2 ">", "3=<" $3 ">", "9=<" $9 ">"
}'

echo ""
echo "Fields beyond NF are empty strings"
echo "The script expects 9 fields ($1 through $9)"
