#!/bin/bash

echo "=== R2 Step 10: Install GNU awk, then rerun RESPONSE 2 unchanged ==="
echo ""

if ! command -v gawk &> /dev/null; then
    echo "gawk is not installed."
    echo "Install with:"
    echo "  macOS: brew install gawk"
    echo "  Linux: sudo apt-get install -y gawk"
    echo ""
    echo "Skipping this test."
    exit 0
fi

# Source the sample values
source ./step2_set_sample_values.sh > /dev/null

echo "Running with gawk explicitly..."
echo ""

echo "${statistics_result_string}" | gawk --assign environment="${environment}" --assign measurement_name="${measurement_name}" '{
    fields = $1 "_count=" $2 "," $1 "_min=" $3 "," $1 "_10p=" $4 "," \
             $1 "_25p=" $5 "," $1 "_50p=" $6 "," $1 "_75p=" $7 "," \
             $1 "_90p=" $8 "," $1 "_max=" $9
    print "resource_usage_" environment ",name=" measurement_name " " fields
}' 2>&1

exit_code=$?
echo ""
echo "Exit code: $exit_code"
echo ""
echo "GNU awk officially supports --assign option"
