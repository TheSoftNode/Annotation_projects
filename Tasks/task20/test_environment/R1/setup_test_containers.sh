#!/bin/bash
# Setup test containers for R1 testing

echo "=== Cleaning up existing test containers and images ==="
docker rm -f c_tag_running c_repo_running c_plain_running buildkit_named c_tag_stopped 2>/dev/null || true
docker image rm local/test:buildkit-alpha local/buildkit-repo:latest local/plain:latest local/test:foo-buildkit 2>/dev/null || true

echo ""
echo "=== Pulling busybox image ==="
docker pull busybox:latest

echo ""
echo "=== Creating test images ==="
docker image tag busybox:latest local/test:buildkit-alpha
docker image tag busybox:latest local/buildkit-repo:latest
docker image tag busybox:latest local/plain:latest
docker image tag busybox:latest local/test:foo-buildkit

echo ""
echo "=== Creating test containers ==="
docker run -d --name c_tag_running local/test:buildkit-alpha sh -c 'sleep 600'
docker run -d --name c_repo_running local/buildkit-repo:latest sh -c 'sleep 600'
docker run -d --name c_plain_running local/plain:latest sh -c 'sleep 600'
docker run -d --name buildkit_named local/plain:latest sh -c 'sleep 600'
docker create --name c_tag_stopped local/test:foo-buildkit sh -c 'echo done'

echo ""
echo "=== Test containers created successfully ==="
echo ""
echo "Ground truth:"
echo "- c_tag_running → image tag contains buildkit"
echo "- c_repo_running → repo contains buildkit, tag is latest"
echo "- c_plain_running → no buildkit anywhere"
echo "- buildkit_named → container name contains buildkit, image does not"
echo "- c_tag_stopped → stopped/created container whose tag contains buildkit"
