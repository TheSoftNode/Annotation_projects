#!/bin/bash

echo "=== R1 Step 11: Verify the newline / empty-record claim ==="
echo ""

statistics_result_string=$'cpu 42 5 10 20 30 40 45 50\n'

echo "Testing with trailing newline in variable:"
echo "${statistics_result_string}" | awk '{ print NR ":<" $0 ">" }'

echo ""
echo "If extra blank record appears, it should be AFTER the data, not before"
