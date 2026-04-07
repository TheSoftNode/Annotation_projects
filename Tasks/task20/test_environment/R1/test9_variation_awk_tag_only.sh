#!/bin/bash
# Test 9: Variation 3 - AWK tag-only matching
# Expected behavior:
# - c_tag_running SHOULD appear (tag has buildkit-alpha)
# - c_repo_running SHOULD NOT appear (repo has buildkit, tag is latest)
# - buildkit_named SHOULD NOT appear (only container name has buildkit)

echo "=== Variation 3: AWK tag-only filter ==="
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" | awk -F':' '{if ($2 ~ /buildkit/) print $0}'
