#!/bin/bash
echo "=== R2 Main Command with jq errors ==="
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"' 2>&1
