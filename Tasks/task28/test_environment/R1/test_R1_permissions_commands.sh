#!/bin/bash
# Test R1's security/permissions commands (Section 5)

echo "========================================"
echo "R1: Permissions & Security Commands"
echo "========================================"
echo ""

# These tests verify the COMMANDS work, not that they're good advice

TEST_DIR="/tmp/r1-perm-test-$$"
TEST_FILE="$TEST_DIR/test-log.txt"
mkdir -p "$TEST_DIR"
touch "$TEST_FILE"

# Test R1-042: groupadd
echo "Test R1-042: groupadd command"
TEST_GROUP="testlogwriters$$"
if sudo groupadd "$TEST_GROUP" 2>/dev/null; then
    echo "✓ groupadd command works"
    sudo groupdel "$TEST_GROUP" 2>/dev/null
else
    echo "⚠ groupadd requires root (expected)"
fi

# Test R1-043: chown root:group
echo ""
echo "Test R1-043: chown root:groupname"
if sudo chown root:root "$TEST_FILE" 2>/dev/null; then
    echo "✓ chown command works"
else
    echo "⚠ chown requires root (expected)"
fi

# Test R1-044: chmod 6640
echo ""
echo "Test R1-044: chmod 6640 (setuid+setgid)"
if chmod 6640 "$TEST_FILE" 2>/dev/null; then
    PERMS=$(stat -c "%a" "$TEST_FILE" 2>/dev/null || stat -f "%p" "$TEST_FILE" 2>/dev/null | tail -c 5)
    if echo "$PERMS" | grep -q "6640"; then
        echo "✓ chmod 6640 works (setuid+setgid+rw-r-----)"
    else
        echo "⚠ chmod 6640 set permissions: $PERMS"
    fi
else
    echo "✗ chmod 6640 failed"
fi

# Test R1-045: chmod 2775 on directory
echo ""
echo "Test R1-045: chmod 2775 (setgid on directory)"
if chmod 2775 "$TEST_DIR" 2>/dev/null; then
    DIR_PERMS=$(stat -c "%a" "$TEST_DIR" 2>/dev/null || stat -f "%p" "$TEST_DIR" 2>/dev/null | tail -c 5)
    if echo "$DIR_PERMS" | grep -q "2775"; then
        echo "✓ chmod 2775 works (setgid+rwxrwxr-x)"
    else
        echo "⚠ chmod 2775 set permissions: $DIR_PERMS"
    fi
else
    echo "✗ chmod 2775 failed"
fi

# Test R1-046: chmod 1730 (sticky bit)
echo ""
echo "Test R1-046: chmod 1730 (sticky bit)"
if chmod 1730 "$TEST_DIR" 2>/dev/null; then
    STICKY_PERMS=$(stat -c "%a" "$TEST_DIR" 2>/dev/null || stat -f "%p" "$TEST_DIR" 2>/dev/null | tail -c 5)
    if echo "$STICKY_PERMS" | grep -q "1730"; then
        echo "✓ chmod 1730 works (sticky+rwx-wx---)"
    else
        echo "⚠ chmod 1730 set permissions: $STICKY_PERMS"
    fi
else
    echo "✗ chmod 1730 failed"
fi

rm -rf "$TEST_DIR"

echo ""
echo "========================================"
echo "R1 Permissions Tests Complete"
echo "========================================"
