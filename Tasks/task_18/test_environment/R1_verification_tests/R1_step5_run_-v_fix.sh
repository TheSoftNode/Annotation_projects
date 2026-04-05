#!/bin/bash

echo "=== R1 Step 5: Run the response's -v fix exactly as written ==="
echo ""

# Source the sample values
source ./R1_step2_set_sample_values.sh > /dev/null

echo "Running R1's -v fix..."
echo ""

# Run R1's -v fix
echo "${statistics_result_string}" |
awk -v environment="${environment}" \
    -v measurement_name="${measurement_name}" '
        {
            output_influxdb_string = "resource_usage_" environment
            output_influxdb_string = output_influxdb_string ",name=" measurement_name
            output_influxdb_string = output_influxdb_string " " $1 "_count=" $2
            output_influxdb_string = output_influxdb_string ", " $1 "_min=" $3
            output_influxdb_string = output_influxdb_string ", " $1 "_10p=" $4
            output_influxdb_string = output_influxdb_string ", " $1 "_25p=" $5
            output_influxdb_string = output_influxdb_string ", " $1 "_50p=" $6
            output_influxdb_string = output_influxdb_string ", " $1 "_75p=" $7
            output_influxdb_string = output_influxdb_string ", " $1 "_90p=" $8
            output_influxdb_string = output_influxdb_string ", " $1 "_max=" $9
            print output_influxdb_string
        }
    ' 2>&1

exit_code=$?
echo ""
echo "Exit code: $exit_code"
