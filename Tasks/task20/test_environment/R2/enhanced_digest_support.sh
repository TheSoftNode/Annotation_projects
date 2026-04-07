#!/bin/bash
# R2 Enhanced Version for Digest Support
docker ps -a --format '{{json .}}' | jq -r 'select( (.Image | contains("buildkit")) and (.Image | contains(":") or .Image | contains("@")) ) | "\(.ID)\t\(.Image)\t\(.Names)"'
