#!/bin/bash
# GPT Factual Test 6: Verify the first service unit as written
# Tests R1's exact service file from section 2.2

echo "=========================================="
echo "GPT Test 6: Service Unit Verbatim Test"
echo "=========================================="
echo ""

SERVICE_FILE="/tmp/group-log-test.service"

echo "Creating EXACT service file from R1 Section 2.2..."
echo ""

sudo tee "$SERVICE_FILE" >/dev/null <<'EOF'
[Unit]
Description=Collect logs from members of the "loggroup" group
After=network.target

[Service]
User=%i
Group=loggroup
ExecStart=/usr/bin/systemd-cat -t group-log
ExecStopPost=/usr/bin/systemd-cat --flush
StandardOutput=journal
StandardError=journal
EOF

echo "✓ Service file created at: $SERVICE_FILE"
echo ""
echo "Service file contents:"
cat "$SERVICE_FILE"
echo ""

# Test 1: Verify syntax
echo "Test 1: systemd-analyze verify"
VERIFY_OUTPUT=$(sudo systemd-analyze verify "$SERVICE_FILE" 2>&1)

echo "$VERIFY_OUTPUT"
echo ""

if echo "$VERIFY_OUTPUT" | grep -qi "error"; then
    echo "✗ Service file has ERRORS"
    echo ""
    echo "Suspicious points noted by GPT:"
    echo "  1. ExecStart=/usr/bin/systemd-cat -t group-log has NO piped input, NO wrapped command"
    echo "  2. ExecStopPost=/usr/bin/systemd-cat --flush is INVALID (--flush belongs to journalctl)"
elif echo "$VERIFY_OUTPUT" | grep -qi "warning"; then
    echo "⚠ Service file has WARNINGS (may still be problematic)"
else
    echo "✓ Service file passed syntax verification"
    echo "  (But this doesn't mean it will work as intended)"
fi

echo ""

# Note about the issues
echo "---"
echo ""
echo "Known issues in this service file (from GPT analysis):"
echo ""
echo "Issue 1: ExecStart has no input"
echo "  Command: /usr/bin/systemd-cat -t group-log"
echo "  Problem: systemd-cat expects input to forward to journal"
echo "  Result: Service will start but do nothing useful"
echo ""
echo "Issue 2: ExecStopPost uses wrong command"
echo "  Command: /usr/bin/systemd-cat --flush"
echo "  Problem: --flush belongs to 'journalctl', not 'systemd-cat'"
echo "  Result: This line will likely fail"
echo ""

# Cleanup
rm -f "$SERVICE_FILE"

echo "Expected result: Service design has fundamental issues"
echo "This is a VERBATIM test - tests R1's exact code as-is"
echo ""
echo "=========================================="
echo "GPT Test 6 Complete"
echo "=========================================="
