#!/bin/bash

echo "=== R1 Step 3: Verify the shell-expansion claim ==="
echo ""

# Source the sample values
source ./R1_step2_set_sample_values.sh > /dev/null

printf '%s\n' "awk --assign environment=${environment} --assign measurement_name=${measurement_name}"
