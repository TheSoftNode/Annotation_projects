#!/bin/bash
# R1 Variation 3 - Exact-match on the tag only
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" | awk -F':' '{if ($2 ~ /buildkit/) print $0}'
