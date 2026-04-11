#!/bin/bash
# Test R2's logger command claim (alternative to systemd-cat)

echo "========================================"
echo "R2: logger Command Test"
echo "========================================"
echo ""

# Test R2-019: logger -t command sends to system logger
echo "Test R2-019: logger -t sends to system logger"

TEST_TAG="logger-test-$$"
TEST_MSG="Logger test message at $(date)"

if command -v logger &> /dev/null; then
    echo "✓ logger command available"

    # Send message via logger
    logger -t "$TEST_TAG" "$TEST_MSG"

    if [ $? -eq 0 ]; then
        echo "✓ logger command executed successfully"

        sleep 1

        # Check if it appears in journal (on systemd systems)
        if command -v journalctl &> /dev/null; then
            FOUND=$(journalctl -t "$TEST_TAG" --since "30 seconds ago" --no-pager 2>/dev/null | grep -F "$TEST_MSG")

            if [ -n "$FOUND" ]; then
                echo "✓ logger message found in journald"
                echo "  Message: $FOUND"
            else
                echo "⚠ logger message not found in journal (may use syslog instead)"
            fi
        fi

        # Check if it appears in syslog
        if [ -f /var/log/syslog ]; then
            if grep -q "$TEST_TAG" /var/log/syslog 2>/dev/null; then
                echo "✓ logger message found in /var/log/syslog"
            fi
        elif [ -f /var/log/messages ]; then
            if grep -q "$TEST_TAG" /var/log/messages 2>/dev/null; then
                echo "✓ logger message found in /var/log/messages"
            fi
        fi
    else
        echo "✗ logger command failed"
    fi
else
    echo "✗ logger command not available on this system"
fi

echo ""
echo "========================================"
echo "R2 logger Tests Complete"
echo "========================================"
