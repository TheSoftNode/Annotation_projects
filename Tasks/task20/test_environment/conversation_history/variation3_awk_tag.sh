#!/bin/bash
# Variation 3 - Exact-match on tag only
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" | awk -F':' '{if ($2 ~ /buildkit/) print $0}'
