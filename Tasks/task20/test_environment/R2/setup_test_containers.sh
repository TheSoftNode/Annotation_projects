#!/bin/bash
# Setup test containers for R2 testing

echo "=== Cleaning up existing test containers and images ==="
docker rm -f c_tag_running c_repo_running c_plain_running buildkit_named c_tag_stopped c_regport c_upper_tag c_digest_running c_child 2>/dev/null || true
docker image rm local/test:buildkit-alpha local/buildkit-repo:latest local/plain:latest localhost:5000/example/plain:buildkit-alpha local/test:BuildKitBeta local/child-of-buildkit:latest 2>/dev/null || true

echo ""
echo "=== Pulling busybox image ==="
docker pull busybox:latest

echo ""
echo "=== Creating test images ==="
docker image tag busybox:latest local/test:buildkit-alpha
docker image tag busybox:latest local/buildkit-repo:latest
docker image tag busybox:latest local/plain:latest
docker image tag busybox:latest localhost:5000/example/plain:buildkit-alpha
docker image tag busybox:latest local/test:BuildKitBeta

echo ""
echo "=== Creating basic test containers ==="
docker run -d --name c_tag_running local/test:buildkit-alpha sh -c 'sleep 600'
docker run -d --name c_repo_running local/buildkit-repo:latest sh -c 'sleep 600'
docker run -d --name c_plain_running local/plain:latest sh -c 'sleep 600'
docker run -d --name buildkit_named local/plain:latest sh -c 'sleep 600'
docker create --name c_tag_stopped local/test:buildkit-alpha sh -c 'echo done'
docker run -d --name c_regport localhost:5000/example/plain:buildkit-alpha sh -c 'sleep 600'
docker run -d --name c_upper_tag local/test:BuildKitBeta sh -c 'sleep 600'

echo ""
echo "=== Creating digest-based container ==="
DIGEST_REF=$(docker image inspect busybox:latest --format '{{index .RepoDigests 0}}')
docker run -d --name c_digest_running "$DIGEST_REF" sh -c 'sleep 600'

echo ""
echo "=== Creating child image and container ==="
mkdir -p /tmp/docker-ancestor-test
cat >/tmp/docker-ancestor-test/Dockerfile <<'EOF'
FROM local/test:buildkit-alpha
CMD ["sh","-c","sleep 600"]
EOF
docker build -t local/child-of-buildkit:latest /tmp/docker-ancestor-test
docker run -d --name c_child local/child-of-buildkit:latest

echo ""
echo "=== Test containers created successfully ==="
echo ""
echo "Ground truth:"
echo "- c_tag_running → image tag contains buildkit"
echo "- c_repo_running → repo contains buildkit, tag is latest"
echo "- c_plain_running → no buildkit anywhere"
echo "- buildkit_named → container name contains buildkit, image does not"
echo "- c_tag_stopped → stopped/created container whose tag contains buildkit"
echo "- c_regport → registry URL with port (localhost:5000), tag contains buildkit"
echo "- c_upper_tag → tag contains BuildKit (uppercase)"
echo "- c_digest_running → digest-based image reference"
echo "- c_child → child image of buildkit-alpha"
