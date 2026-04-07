#!/bin/bash
# Test 7: Variation 1 - Include stopped containers (should show c_tag_stopped)

echo "=== Variation 1: Include stopped containers ==="
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
