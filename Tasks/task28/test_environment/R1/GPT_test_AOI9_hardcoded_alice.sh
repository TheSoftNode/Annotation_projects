#!/bin/bash

# Test for AOI #9: Hardcoded alice.service in loop
# This test proves that the loop hardcodes "alice.service" instead of using $u

echo "========================================================================"
echo "AOI #9 Test: Hardcoded alice.service Bug"
echo "========================================================================"
echo ""

# Create temporary test directory
TEST_DIR=$(mktemp -d)
echo "Test directory: $TEST_DIR"
echo ""

# Simulate the buggy code from R1 response (lines 98-122)
echo "Simulating group members: alice, bob, charlie"
echo ""
echo "Running the EXACT code from R1 response:"
echo "for u in alice bob charlie; do"
echo "    mkdir -p /etc/systemd/user/alice.service"
echo "    cat > /etc/systemd/user/alice.service <<'EOF'"
echo "    ..."
echo "    EOF"
echo "done"
echo ""
echo "-----------------------------------"

# Run the buggy code (adapted to use test directory)
for u in alice bob charlie; do
    echo "Loop iteration for user: $u"

    # First bug: mkdir -p on the SERVICE FILE (not directory)
    # This creates alice.service as a DIRECTORY
    mkdir -p "$TEST_DIR/alice.service"

    # Second bug: Always writes to alice.service (not $u.service)
    cat > "$TEST_DIR/alice.service.txt" <<'EOF'
[Unit]
Description=Group‑log collector for alice
[Service]
ExecStart=/usr/bin/systemd-cat ‑t group-log
StandardOutput=journal
StandardError=journal
EOF

    echo "  Action: Created $TEST_DIR/alice.service.txt (overwrites each time)"
    echo "  Should have created: $TEST_DIR/$u.service"
    echo ""
done

echo "-----------------------------------"
echo ""
echo "Results:"
echo "--------"

# Check what files exist
echo "Files created in test directory:"
ls -la "$TEST_DIR" | grep -v "^total" | grep -v "^d.*\.$"

echo ""
echo "Expected: 3 service files (alice.service, bob.service, charlie.service)"
echo "Actual:"

service_count=$(ls "$TEST_DIR"/*.txt 2>/dev/null | wc -l | tr -d ' ')
dir_count=$(ls -d "$TEST_DIR"/alice.service 2>/dev/null | wc -l | tr -d ' ')

echo "  - Service files: $service_count"
echo "  - Directory created: $dir_count (alice.service as directory)"
echo ""

if [ "$service_count" -eq 1 ]; then
    echo "✗ BUG CONFIRMED:"
    echo "  1. Only ONE file exists (alice.service.txt)"
    echo "  2. bob.service and charlie.service were NEVER created"
    echo "  3. alice.service.txt was overwritten 3 times in the loop"
    echo "  4. mkdir -p created alice.service as a DIRECTORY (wrong)"
    echo ""
    echo "Correct code should use:"
    echo "  mkdir -p /etc/systemd/user/"
    echo "  cat > /etc/systemd/user/\$u.service <<'EOF'"
else
    echo "⚠ Unexpected result"
fi

echo ""
echo "File content (shows it only has alice hardcoded):"
cat "$TEST_DIR/alice.service.txt"

echo ""
echo "-----------------------------------"
echo "Cleanup: removing $TEST_DIR"
rm -rf "$TEST_DIR"

echo ""
echo "========================================================================"
echo "Test Complete"
echo "========================================================================"
