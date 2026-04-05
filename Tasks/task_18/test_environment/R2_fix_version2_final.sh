#!/bin/bash

# R2 Fix Version 2 (Final): Cleaner version using fields variable
echo "${statistics_result_string}" | awk --assign environment="${environment}" --assign measurement_name="${measurement_name}" '{
    fields = $1 "_count=" $2 "," $1 "_min=" $3 "," $1 "_10p=" $4 "," \
             $1 "_25p=" $5 "," $1 "_50p=" $6 "," $1 "_75p=" $7 "," \
             $1 "_90p=" $8 "," $1 "_max=" $9
    print "resource_usage_" environment ",name=" measurement_name " " fields
}'
