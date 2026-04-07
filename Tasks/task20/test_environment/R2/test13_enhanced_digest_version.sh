#!/bin/bash
# Test 13: Test enhanced version for digest support

echo "=== Enhanced version with digest support ==="
docker ps -a --format '{{json .}}' | jq -r 'select( (.Image | contains("buildkit")) and (.Image | contains(":") or .Image | contains("@")) ) | "\(.ID)\t\(.Image)\t\(.Names)"'

echo ""
echo "Check if this defeats the stated purpose by matching entire image string like grep"
