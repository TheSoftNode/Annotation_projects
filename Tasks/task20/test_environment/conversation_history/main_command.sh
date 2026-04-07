#!/bin/bash
# Main command from conversation history
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
