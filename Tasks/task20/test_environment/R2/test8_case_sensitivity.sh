#!/bin/bash
# Test 8: Test case sensitivity

echo "=== Case-sensitive (default) - should NOT match c_upper_tag ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'

echo ""
echo "=== Case-insensitive with ascii_downcase - should match c_upper_tag ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | ascii_downcase | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
