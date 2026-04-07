#!/bin/bash
# Test 6: Check {{.Image}} vs {{.Config.Image}} in docker inspect
# This tests whether the response's claim about "full image reference" is accurate

echo "=== Using {{.Image}} (response uses this) ==="
docker inspect c_tag_running --format '{{.Image}}'

echo ""
echo "=== Using {{.Config.Image}} (Docker docs recommend this for image name) ==="
docker inspect c_tag_running --format '{{.Config.Image}}'
