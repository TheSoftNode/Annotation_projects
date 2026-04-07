#!/bin/bash
# R2 Fallback grep Method
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i ':[^:]*buildkit'
