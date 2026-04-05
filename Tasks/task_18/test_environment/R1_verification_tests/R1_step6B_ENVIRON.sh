#!/bin/bash

echo "=== R1 Step 6B: Verify the ENVIRON claim ==="
echo ""

export environment=prod
export measurement_name=latency

echo "Testing ENVIRON array..."
awk 'BEGIN { print "env=<" ENVIRON["environment"] ">", "name=<" ENVIRON["measurement_name"] ">" }'
