#!/bin/bash
# GPT Factual Test 8: Verify group-logger script manually
# Tests R1's group-logger wrapper script from section 2.4

echo "=========================================="
echo "GPT Test 8: Group Logger Script Test"
echo "=========================================="
echo ""

SCRIPT_FILE="/tmp/group-logger-test.sh"

echo "Creating R1's EXACT group-logger script from Section 2.4..."
echo ""

cat > "$SCRIPT_FILE" <<'EOF'
#!/bin/bash
# /usr/local/bin/group-logger
exec systemd-cat -p info -t group-logger
EOF

chmod +x "$SCRIPT_FILE"

echo "✓ Script created at: $SCRIPT_FILE"
echo ""
echo "Script contents:"
cat "$SCRIPT_FILE"
echo ""

# Test 1: Verify script syntax
echo "Test 1: Script syntax verification"
bash -n "$SCRIPT_FILE"
SYNTAX_EXIT=$?

if [ $SYNTAX_EXIT -eq 0 ]; then
    echo "✓ Script has valid bash syntax"
else
    echo "✗ Script has syntax errors"
fi

echo ""

# Test 2: Test the script manually
echo "Test 2: Manual test of the script"
echo ""

echo "Running: echo 'Test message' | $SCRIPT_FILE"
echo "Expected: Message appears in journal with identifier 'group-logger'"
echo ""

# Send test message
echo "Test message from GPT Test 8 at $(date)" | "$SCRIPT_FILE"

# Give journald a moment to process
sleep 1

# Check if it appears in journal
echo "Checking journal for the message..."
JOURNAL_OUTPUT=$(journalctl -t group-logger -n 5 --no-pager)

echo "$JOURNAL_OUTPUT"
echo ""

if echo "$JOURNAL_OUTPUT" | grep -q "Test message from GPT Test 8"; then
    echo "✓ Message successfully logged to journal"
    echo "✓ Identifier 'group-logger' works correctly"
else
    echo "✗ Message not found in journal"
fi

echo ""

# Test 3: Verify behavior with multiple lines
echo "Test 3: Multi-line input test"
echo ""

echo "Sending multiple lines to the script..."
(
    echo "Line 1: Start of work"
    echo "Line 2: Processing data"
    echo "Line 3: End of work"
) | "$SCRIPT_FILE"

sleep 1

echo "Journal entries for group-logger (last 10):"
journalctl -t group-logger -n 10 --no-pager

echo ""

# Test 4: Analyze the script's design
echo "---"
echo ""
echo "Analysis of R1's group-logger script design:"
echo ""
echo "What it does:"
echo "  1. Uses 'exec' to replace the shell with systemd-cat"
echo "  2. Sets priority to 'info' (-p info)"
echo "  3. Sets identifier to 'group-logger' (-t group-logger)"
echo "  4. Reads from stdin and forwards to journal"
echo ""
echo "Design characteristics:"
echo "  ✓ Simple wrapper that makes systemd-cat easier to use"
echo "  ✓ 'exec' is efficient (no extra process)"
echo "  ✓ Works well as a pipeline endpoint"
echo ""
echo "Usage pattern (from R1):"
echo "  echo 'Starting work' | /usr/local/bin/group-logger"
echo "  ./my-script.sh | /usr/local/bin/group-logger"
echo ""

# Cleanup
rm -f "$SCRIPT_FILE"

echo "Expected result: Script works correctly as a systemd-cat wrapper"
echo "This is a VERBATIM test - tests R1's exact script as-is"
echo ""
echo "=========================================="
echo "GPT Test 8 Complete"
echo "=========================================="
