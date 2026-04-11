#!/usr/bin/env bash

# This script demonstrates the hardcoded alice.service bug from R1
# by actually running the exact code from the response

echo "================================================"
echo "Testing AOI #9: Hardcoded alice.service in loop"
echo "================================================"
echo ""

# Create a temporary test directory structure
TEST_DIR=$(mktemp -d)
mkdir -p "$TEST_DIR/etc/systemd/user"

echo "Test directory: $TEST_DIR"
echo ""
echo "Simulating getent group loggroup output with alice, bob, charlie..."
echo ""

# Run the EXACT code from R1 response (lines 98-122)
# but redirect file creation to our test directory
cd "$TEST_DIR" || exit 1

echo "Running the loop from R1 response:"
echo "-----------------------------------"

for u in alice bob charlie; do
    echo "Iteration: Processing user '$u'"

    # This is the EXACT buggy code from the response
    mkdir -p etc/systemd/user/alice.service

    cat > etc/systemd/user/alice.service <<'EOF'
[Unit]
Description=Group‑log collector for alice
[Service]
ExecStart=/usr/bin/systemd-cat ‑t group-log
StandardOutput=journal
StandardError=journal
EOF

    echo "  Created: etc/systemd/user/alice.service"
    echo ""
done

echo "-----------------------------------"
echo "Loop completed."
echo ""
echo "Expected result: 3 files (alice.service, bob.service, charlie.service)"
echo "Actual result:"
echo ""

# Show what files actually exist
echo "Files in etc/systemd/user/:"
ls -la "$TEST_DIR/etc/systemd/user/" | tail -n +4

echo ""
echo "File count:"
file_count=$(find "$TEST_DIR/etc/systemd/user/" -type f | wc -l | tr -d ' ')
echo "  Found: $file_count file(s)"
echo "  Expected: 3 files"
echo ""

if [ "$file_count" -eq 1 ]; then
    echo "✗ BUG CONFIRMED: Only alice.service exists"
    echo "  The loop hardcoded 'alice.service' instead of using '\$u.service'"
    echo "  bob.service and charlie.service were NEVER created"
    echo "  alice.service was overwritten 3 times"
else
    echo "✓ No bug found (unexpected)"
fi

echo ""
echo "Cleanup: Removing $TEST_DIR"
rm -rf "$TEST_DIR"
