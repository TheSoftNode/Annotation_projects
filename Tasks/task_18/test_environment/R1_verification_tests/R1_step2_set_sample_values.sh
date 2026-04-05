#!/bin/bash

echo "=== R1 Step 2: Set clean sample values ==="
echo ""

statistics_result_string='cpu 42 5 10 20 30 40 45 50'
environment=prod
measurement_name=latency

printf 'environment=<%s>\nmeasurement_name=<%s>\nstatistics_result_string=<%s>\n' \
  "$environment" "$measurement_name" "$statistics_result_string"

# Export for other scripts
export statistics_result_string environment measurement_name
