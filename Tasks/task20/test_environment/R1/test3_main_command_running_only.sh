#!/bin/bash
# Test 3: Main command - running containers only (should NOT show c_tag_stopped)

echo "=== Main Command: Running containers with buildkit filter ==="
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
