#!/bin/bash

echo "=== R2 Step 2: Set the exact sample values from RESPONSE 2 ==="
echo ""

statistics_result_string="cpu 100 1 2 3 4 5 6 10"
environment="prod"
measurement_name="server1"

echo "Values set:"
echo "statistics_result_string=\"$statistics_result_string\""
echo "environment=\"$environment\""
echo "measurement_name=\"$measurement_name\""

# Export for other scripts
export statistics_result_string environment measurement_name
