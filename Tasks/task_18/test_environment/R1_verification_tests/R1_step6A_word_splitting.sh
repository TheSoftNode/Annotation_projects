#!/bin/bash

echo "=== R1 Step 6A: Verify the word-splitting claim ==="
echo ""

environment='prod west'
measurement_name='latency p95'

echo "Testing with spaces in values:"
echo "environment='$environment'"
echo "measurement_name='$measurement_name'"
echo ""

echo "UNQUOTED version:"
awk -v environment=${environment} -v measurement_name=${measurement_name} 'BEGIN { print "env=<" environment ">", "name=<" measurement_name ">" }' 2>&1
echo ""

echo "QUOTED version:"
awk -v environment="${environment}" -v measurement_name="${measurement_name}" 'BEGIN { print "env=<" environment ">", "name=<" measurement_name ">" }'
