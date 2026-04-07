#!/bin/bash
# Test 5: Verify table format produces header row

echo "=== Table format with header (should have CONTAINER ID, IMAGE, NAMES header) ==="
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}"
