#!/bin/bash
# GPT Factual Test 3 (R2): Verify the logger alternative exactly
# Tests R2's Code Test 3 from GPT_FACTUAL_R2_TASK28.md (lines 301-310)

echo "=========================================="
echo "GPT Test 3 (R2): logger Alternative"
echo "=========================================="
echo ""

echo "Testing R2's claim about logger as alternative to systemd-cat"
echo ""

echo "Running exact command from GPT Code Test 3:"
echo "logger -t myscript \"Script started by \$USER\""
echo ""

logger -t myscript "Script started by $USER"

# Give syslog/journal a moment
sleep 1

echo "Querying journal: journalctl -t myscript --no-pager -n 20"
echo ""

journalctl -t myscript --no-pager -n 20

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  You should see the new message in journal or system log view"
echo "  This verifies that logger writes to system log and -t sets tag"
echo "  On a systemd machine, it commonly shows up in journalctl"
echo ""
echo "Claims tested:"
echo "  • logger -t myscript \"Script started by \$USER\""
echo "  • logger sends logs to system logger (often journald on systemd)"
echo ""
echo "=========================================="
echo "GPT Test 3 (R2) Complete"
echo "=========================================="
