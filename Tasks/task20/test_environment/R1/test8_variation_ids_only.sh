#!/bin/bash
# Test 8: Variation 2 - Show only container IDs
# Check if output is only IDs and if {{.Id}} works vs {{.Config.Image}}

echo "=== Variation 2: Container IDs only ==="
docker ps -aq | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
