#!/bin/bash
# Test 2: Baseline ground truth - show all containers

echo "=== Baseline: All containers with format ==="
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}"
