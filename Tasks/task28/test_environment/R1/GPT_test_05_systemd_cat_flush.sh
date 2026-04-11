#!/bin/bash
# GPT Factual Test 5: Verify that systemd-cat --flush is suspect
# Tests claim 17: ExecStopPost=/usr/bin/systemd-cat --flush is wrong

echo "=========================================="
echo "GPT Test 5: systemd-cat --flush is WRONG"
echo "=========================================="
echo ""

echo "R1 claims: 'ExecStopPost=/usr/bin/systemd-cat --flush'"
echo "Testing whether --flush belongs to systemd-cat or journalctl..."
echo ""

# Command 1
echo "Command 1: systemd-cat --help"
echo ""
SYSTEMD_CAT_HELP=$(systemd-cat --help 2>&1)
echo "$SYSTEMD_CAT_HELP"
echo ""

if echo "$SYSTEMD_CAT_HELP" | grep -qi "flush"; then
    echo "✗ UNEXPECTED: --flush found in systemd-cat help"
else
    echo "✓ CONFIRMED: --flush NOT in systemd-cat help"
fi

echo ""
echo "---"
echo ""

# Command 2
echo "Command 2: journalctl --help | grep flush"
echo ""
JOURNALCTL_FLUSH=$(journalctl --help 2>&1 | grep -i flush)
echo "$JOURNALCTL_FLUSH"
echo ""

if [ -n "$JOURNALCTL_FLUSH" ]; then
    echo "✓ CONFIRMED: --flush found in journalctl help"
    echo "  --flush belongs to JOURNALCTL, not systemd-cat"
else
    echo "⚠ --flush not found in journalctl help (may need to check man page)"
fi

echo ""
echo "---"
echo ""

# Additional check: Try the command
echo "Test: systemd-cat --flush"
if systemd-cat --flush 2>&1 | grep -qi "unrecognized\|invalid\|unknown"; then
    echo "✓ CONFIRMED: systemd-cat rejects --flush option"
elif systemd-cat --flush 2>&1 | grep -qi "flush"; then
    echo "✗ UNEXPECTED: systemd-cat accepted --flush"
else
    echo "⚠ Unclear result"
fi

echo ""
echo "Expected result: --flush is under journalctl, NOT systemd-cat"
echo "This DISPROVES R1's claim 17: 'ExecStopPost=/usr/bin/systemd-cat --flush'"
echo ""
echo "Correct command would be: journalctl --flush"
echo ""
echo "=========================================="
echo "GPT Test 5 Complete"
echo "=========================================="
