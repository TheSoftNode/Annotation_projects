#!/bin/bash
# R2 Main Single-Line Command (Exact Tag Substring Match)
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
