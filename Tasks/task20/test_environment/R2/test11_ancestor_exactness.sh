#!/bin/bash
# Test 11: Test if ancestor filter is truly "exact" or includes descendants

echo "=== Ancestor filter with exact image (should match container AND descendants) ==="
docker ps --filter "ancestor=local/test:buildkit-alpha"

echo ""
echo "Expected: Should show c_tag_running AND c_child (descendant)"
echo "This disputes the claim that ancestor 'only matches EXACT image references'"
