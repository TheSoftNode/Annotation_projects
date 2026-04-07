#!/bin/bash
# Test 4: Verify docker ps vs docker ps -a behavior

echo "=== docker ps (should omit c_tag_stopped) ==="
docker ps

echo ""
echo "=== docker ps -a (should include c_tag_stopped) ==="
docker ps -a
