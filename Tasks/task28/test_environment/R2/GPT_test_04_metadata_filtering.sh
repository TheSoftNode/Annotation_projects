#!/bin/bash
# GPT Factual Test 4 (R2): Verify the metadata/filtering claim
# Tests R2's Code Test 4 from GPT_FACTUAL_R2_TASK28.md (lines 312-321)

echo "=========================================="
echo "GPT Test 4 (R2): Metadata & Filtering"
echo "=========================================="
echo ""

echo "Testing R2's claim about structured logs with metadata"
echo ""

echo "Running exact command from GPT Code Test 4:"
echo "echo \"Metadata test from \$USER\" | systemd-cat -t myscript -p info"
echo ""

echo "Metadata test from $USER" | systemd-cat -t myscript -p info

# Give journald a moment
sleep 1

echo "Querying with verbose output: journalctl -t myscript --no-pager -n 5 -o verbose"
echo ""

journalctl -t myscript --no-pager -n 5 -o verbose

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  In verbose output you should inspect metadata fields"
echo "  Look for fields such as:"
echo "    • _UID= (user ID)"
echo "    • _PID= (process ID)"
echo "    • SYSLOG_IDENTIFIER=myscript"
echo ""
echo "Claim tested:"
echo "  journald supports structured logs with metadata"
echo "  (timestamp, user, PID, command, etc.)"
echo ""
echo "=========================================="
echo "GPT Test 4 (R2) Complete"
echo "=========================================="
