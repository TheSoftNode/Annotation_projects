#!/bin/bash
# R2 Variation 2 - Case-insensitive match (add ascii_downcase)
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | ascii_downcase | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
