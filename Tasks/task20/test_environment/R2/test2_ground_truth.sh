#!/bin/bash
# Test 2: Record ground truth

echo "=== Ground Truth: Container Name -> Image ==="
docker inspect --format '{{.Name}} -> {{.Config.Image}}' c_tag_running c_repo_running c_plain_running buildkit_named c_tag_stopped c_regport c_upper_tag c_digest_running c_child

echo ""
echo "=== All Containers JSON ==="
docker ps -a --format json
