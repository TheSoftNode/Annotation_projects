#!/bin/bash
# Test 12: Test grep fallback method

echo "=== Grep fallback with regex pattern ==="
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i ':[^:]*buildkit'

echo ""
echo "Check if this has false positives with:"
echo "- c_repo_running (buildkit in repo)"
echo "- c_regport (registry with port)"
