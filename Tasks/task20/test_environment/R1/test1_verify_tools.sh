#!/bin/bash
# Test 1: Verify Docker and helper tools exist

echo "=== Docker Version ==="
docker version

echo ""
echo "=== Helper Tools Check ==="
which grep awk cut xargs
