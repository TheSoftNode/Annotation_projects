#!/bin/bash
# Test 7: Test digest-based image handling

echo "=== Digest-based image .Image field ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Names=="c_digest_running") | .Image'

echo ""
echo "=== Main command with digest container ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"' | grep c_digest || echo "c_digest_running NOT matched"
