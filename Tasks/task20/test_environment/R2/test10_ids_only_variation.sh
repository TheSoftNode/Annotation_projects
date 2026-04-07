#!/bin/bash
# Test 10: Variation - IDs only for scripting

echo "=== Only container IDs ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | .ID'
