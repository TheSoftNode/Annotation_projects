#!/bin/bash

# Test the ORIGINAL user code with gawk (variables set correctly)
statistics_result_string="cpu 42 5 10 20 30 40 45 50"
environment="prod"
measurement_name="latency"

echo "=== Testing ORIGINAL code with gawk (--assign should work) ==="
echo "${statistics_result_string}" | gawk --assign environment="${environment}" --assign measurement_name="${measurement_name}" '{
            output_influxdb_string="resource_usage_" environment
            output_influxdb_string+=",name=" measurement_name
            output_influxdb_string+=" " $1 "_count=" $2
            output_influxdb_string+=", " $1 "_min=" $3
            output_influxdb_string+=", " $1 "_10p=" $4
            output_influxdb_string+=", " $1 "_25p=" $5
            output_influxdb_string+=", " $1 "_50p=" $6
            output_influxdb_string+=", " $1 "_75p=" $7
            output_influxdb_string+=", " $1 "_90p=" $8
            output_influxdb_string+=", " $1 "_max=" $9
            print output_influxdb_string
        }'

echo ""
echo "Exit code: $?"
