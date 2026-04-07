#!/bin/bash
# Test 4: Test docker ps JSON output format

echo "=== docker ps -a with JSON format ==="
docker ps -a --format '{{json .}}'
