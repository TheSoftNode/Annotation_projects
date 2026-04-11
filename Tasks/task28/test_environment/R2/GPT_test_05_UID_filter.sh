#!/bin/bash
# GPT Factual Test 5 (R2): Verify the _UID filter example
# Tests R2's Code Test 5 from GPT_FACTUAL_R2_TASK28.md (lines 323-334)

echo "=========================================="
echo "GPT Test 5 (R2): _UID Filter Test"
echo "=========================================="
echo ""

echo "Testing R2's claim about filtering by _UID"
echo ""

# Get current UID
MY_UID=$(id -u)

echo "Current user: $USER"
echo "Current UID: $MY_UID"
echo ""

# Send a test message
echo "Sending test message..."
echo "UID filter test from $USER (UID=$MY_UID)" | systemd-cat -t myscript -p info

sleep 1

echo ""
echo "Running exact command from GPT Code Test 5:"
echo "journalctl _UID=\$(id -u) -t myscript --no-pager -n 20"
echo ""

journalctl _UID=$(id -u) -t myscript --no-pager -n 20

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  You should see only 'myscript' entries associated with your UID"
echo "  This directly tests the 'journalctl _UID=1001' style claim"
echo ""
echo "Claim tested:"
echo "  journalctl _UID=1001 (using actual UID: $MY_UID)"
echo ""
echo "=========================================="
echo "GPT Test 5 (R2) Complete"
echo "=========================================="
