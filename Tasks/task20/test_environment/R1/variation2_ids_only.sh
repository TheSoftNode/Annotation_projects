#!/bin/bash
# R1 Variation 2 - Show only the container IDs
docker ps -aq | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
