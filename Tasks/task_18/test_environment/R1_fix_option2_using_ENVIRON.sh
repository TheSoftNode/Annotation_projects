#!/bin/bash

# R1 Fix Option 2: Export the variables and let awk read them from ENVIRON
export environment measurement_name
echo "${statistics_result_string}" |
awk '
        {
            output_influxdb_string = "resource_usage_" ENVIRON["environment"]
            output_influxdb_string = output_influxdb_string ",name=" ENVIRON["measurement_name"]
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
    '
