#!/bin/bash
# GPT Factual Test 2: _UID= filtering
# Tests claim 14: journalctl _UID= field matching

echo "=========================================="
echo "GPT Test 2: _UID= Filtering"
echo "=========================================="
echo ""

echo "Running EXACT command from GPT Factual document..."
echo ""

MYUID=$(id -u)
echo "Current UID: $MYUID"
echo ""

echo "Command: journalctl _UID=\$(id -u) -t group-script -n 20 --no-pager"
OUTPUT=$(journalctl _UID=$MYUID -t group-script -n 20 --no-pager)

echo "$OUTPUT"
echo ""

# Verify entries appear
if [ -n "$OUTPUT" ]; then
    echo "✓ Entries found with _UID=$MYUID filtering"
    echo "  Entry count: $(echo "$OUTPUT" | grep -c "group-script")"
else
    echo "✗ No entries found with _UID filtering"
fi

echo ""
echo "Expected result: Should see entries filtered by UID plus tag"
echo "This tests: _UID= field match is separate from -u/--unit"
echo ""
echo "=========================================="
echo "GPT Test 2 Complete"
echo "=========================================="
