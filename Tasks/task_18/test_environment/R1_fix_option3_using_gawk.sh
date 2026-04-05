#!/bin/bash

# R1 Fix Option 3: If you really want to keep the --assign syntax, use GNU awk (gawk) explicitly
gawk --assign environment="${environment}" \
     --assign measurement_name="${measurement_name}" '{
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
        }' <<< "${statistics_result_string}"
