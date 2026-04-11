#!/bin/bash
# GPT Factual Test 1: Basic systemd-cat one-liner
# Tests claims: systemd-cat as pipeline filter, -p sets priority, -t sets identifier

echo "=========================================="
echo "GPT Test 1: Basic systemd-cat One-liner"
echo "=========================================="
echo ""

echo "Running EXACT commands from GPT Factual document..."
echo ""

# Command 1
echo "Command 1: echo 'Starting work at \$(date)' | systemd-cat -p info -t group-script"
echo "Starting work at $(date)" | systemd-cat -p info -t group-script

if [ $? -eq 0 ]; then
    echo "✓ Command 1 executed successfully"
else
    echo "✗ Command 1 failed"
fi

sleep 1

# Command 2
echo ""
echo "Command 2: echo 'Finished work at \$(date)' | systemd-cat -p info -t group-script"
echo "Finished work at $(date)" | systemd-cat -p info -t group-script

if [ $? -eq 0 ]; then
    echo "✓ Command 2 executed successfully"
else
    echo "✗ Command 2 failed"
fi

sleep 2

# Command 3: Verify in journal
echo ""
echo "Command 3: journalctl -t group-script -n 20 --no-pager"
OUTPUT=$(journalctl -t group-script -n 20 --no-pager)

echo "$OUTPUT"
echo ""

# Verify both messages appear
if echo "$OUTPUT" | grep -q "Starting work"; then
    echo "✓ First message found in journal"
else
    echo "✗ First message NOT found"
fi

if echo "$OUTPUT" | grep -q "Finished work"; then
    echo "✓ Second message found in journal"
else
    echo "✗ Second message NOT found"
fi

echo ""
echo "Expected result: Two journal entries tagged with 'group-script'"
echo "This tests: systemd-cat as pipeline filter, -p sets priority, -t sets identifier"
echo ""
echo "=========================================="
echo "GPT Test 1 Complete"
echo "=========================================="
