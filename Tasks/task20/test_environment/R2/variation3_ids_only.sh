#!/bin/bash
# R2 Variation 3 - Only container IDs (for scripting)
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | .ID'
