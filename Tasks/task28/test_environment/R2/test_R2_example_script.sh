#!/bin/bash
# Test R2's example script (Section: Example: Using systemd-cat)

echo "========================================"
echo "R2: Example Script Test"
echo "========================================"
echo ""

# R2's exact example from the response
# Test R2-013: echo | systemd-cat -t myscript -p info

TEST_TAG="myscript-$$"

echo "Test R2-013: R2's example script"
echo "Running R2's exact example..."

# Line 1 from R2's example
echo "Script started by $USER" | systemd-cat -t "$TEST_TAG" -p info

if [ $? -eq 0 ]; then
    echo "✓ First systemd-cat command succeeded"
else
    echo "✗ First systemd-cat command failed"
    exit 1
fi

# Simulate work
sleep 1

# Line 2 from R2's example
echo "Processing complete" | systemd-cat -t "$TEST_TAG" -p info

if [ $? -eq 0 ]; then
    echo "✓ Second systemd-cat command succeeded"
else
    echo "✗ Second systemd-cat command failed"
fi

sleep 1

# Test R2-014: journalctl -t myscript
echo ""
echo "Test R2-014: journalctl -t myscript filtering"
FILTERED=$(journalctl -t "$TEST_TAG" --since "1 minute ago" --no-pager)

if echo "$FILTERED" | grep -q "Script started by $USER"; then
    echo "✓ First message found in journal"
else
    echo "✗ First message NOT found"
fi

if echo "$FILTERED" | grep -q "Processing complete"; then
    echo "✓ Second message found in journal"
else
    echo "✗ Second message NOT found"
fi

# Test R2-015: journalctl -t myscript -b
echo ""
echo "Test R2-015: journalctl -b (current boot)"
BOOT_FILTERED=$(journalctl -t "$TEST_TAG" -b --no-pager)

if [ -n "$BOOT_FILTERED" ]; then
    echo "✓ journalctl -b filtering works"
    echo "  Found $(echo "$BOOT_FILTERED" | grep -c "$TEST_TAG") entries"
else
    echo "✗ journalctl -b filtering failed"
fi

echo ""
echo "========================================"
echo "R2 Example Script Tests Complete"
echo "========================================"
