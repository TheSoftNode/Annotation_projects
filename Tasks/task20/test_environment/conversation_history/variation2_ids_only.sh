#!/bin/bash
# Variation 2 - Show only container IDs
docker ps -aq --filter "status=running" | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
