#!/bin/bash

echo "=== R2 Step 8: Test the quoting claim ==="
echo ""

environment='prod west'
measurement_name='server 1'

echo "Testing with spaces in values:"
echo "environment='$environment'"
echo "measurement_name='$measurement_name'"
echo ""

echo "UNQUOTED version:"
awk --assign environment=${environment} --assign measurement_name=${measurement_name} 'BEGIN { print environment, measurement_name }' 2>&1

echo ""
echo "QUOTED version:"
awk --assign environment="${environment}" --assign measurement_name="${measurement_name}" 'BEGIN { print environment, measurement_name }' 2>&1

echo ""
echo "Quoted version preserves spaces in values"
