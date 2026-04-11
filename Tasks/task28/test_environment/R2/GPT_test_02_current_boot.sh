#!/bin/bash
# GPT Factual Test 2 (R2): Verify the current-boot example exactly
# Tests R2's Code Test 2 from GPT_FACTUAL_R2_TASK28.md (lines 292-299)

echo "=========================================="
echo "GPT Test 2 (R2): Current Boot Filter (-b)"
echo "=========================================="
echo ""

echo "First, sending a test message to journal..."
echo "Test message from current boot at $(date)" | systemd-cat -t myscript -p info

sleep 1

echo ""
echo "Running exact command from GPT Code Test 2:"
echo "journalctl -t myscript -b --no-pager -n 20"
echo ""

journalctl -t myscript -b --no-pager -n 20

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  You should see only entries from the current boot for identifier 'myscript'"
echo "  -b with no argument means current boot"
echo ""
echo "Claim tested:"
echo "  journalctl -t myscript -b filters by identifier and current boot"
echo ""
echo "=========================================="
echo "GPT Test 2 (R2) Complete"
echo "=========================================="
