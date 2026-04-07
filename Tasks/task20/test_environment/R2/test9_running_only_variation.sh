#!/bin/bash
# Test 9: Variation - running containers only (no -a flag)

echo "=== Running containers only (should NOT show c_tag_stopped) ==="
docker ps --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
