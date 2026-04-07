#!/bin/bash
# From conversation history table - format command only (this is incomplete, just the format part)
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}"
