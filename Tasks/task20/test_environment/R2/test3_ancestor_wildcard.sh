#!/bin/bash
# Test 3: Test ancestor filter with wildcards (should not work)

echo "=== Ancestor filter with wildcards (should not work as substring match) ==="
docker ps --filter "ancestor=*buildkit*"

echo ""
echo "=== Ancestor filter with exact reference ==="
docker ps --filter "ancestor=local/test:buildkit-alpha"
