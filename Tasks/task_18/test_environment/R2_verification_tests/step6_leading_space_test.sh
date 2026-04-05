#!/bin/bash

echo "=== R2 Step 6: Test the 'leading space is the real issue' claim ==="
echo ""

echo "Printing a literal line with ONE space between tags and fields:"
awk 'BEGIN {
    print "resource_usage_prod,name=server1 cpu_count=100,cpu_min=1"
}'

echo ""
echo "InfluxDB requires ONE space delimiter between measurement/tag set and field set."
echo "This is part of the documented format, not an error."
