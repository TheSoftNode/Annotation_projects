#!/bin/bash
# R1 Main One-liner (running containers only)
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
