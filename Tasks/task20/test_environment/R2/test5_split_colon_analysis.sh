#!/bin/bash
# Test 5: Analyze how split(":") works on different image formats

echo "=== c_tag_running: plain repo:tag ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Names=="c_tag_running") | .Image, (.Image | split(":"))'

echo ""
echo "=== c_regport: registry with port ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Names=="c_regport") | .Image, (.Image | split(":"))'

echo ""
echo "=== c_digest_running: digest-based image ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Names=="c_digest_running") | .Image, (.Image | split(":"))'
