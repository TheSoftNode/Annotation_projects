#!/bin/bash
# Test 6: Test main jq command - should match tag portion only

echo "=== Main jq command: Tag-only matching ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'

echo ""
echo "Expected:"
echo "- c_tag_running SHOULD appear (tag has buildkit)"
echo "- c_repo_running SHOULD NOT appear (repo has buildkit, tag is latest)"
echo "- buildkit_named SHOULD NOT appear (only name has buildkit)"
echo "- c_regport test for registry:port handling"
