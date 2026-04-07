#!/bin/bash
# R1 Variation 1 - Include stopped containers
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
