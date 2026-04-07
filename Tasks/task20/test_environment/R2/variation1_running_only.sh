#!/bin/bash
# R2 Variation 1 - Running containers only (remove -a)
docker ps --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
