#!/bin/bash
# GPT Factual Test 7 (R2): Verify the "atomic and thread-safe" claim manually
# Tests R2's Code Test 7 from GPT_FACTUAL_R2_TASK28.md (lines 351-378)

echo "=========================================="
echo "GPT Test 7 (R2): Atomic/Thread-Safe Test"
echo "=========================================="
echo ""

echo "Testing R2's claim:"
echo "  'journald ensures log entries are written atomically,"
echo "   avoiding garbled output from concurrent writes'"
echo ""
echo "⚠ WARNING: GPT document notes this is STRONGER than"
echo "   what the manuals actually state"
echo ""

echo "Running concurrent writers test..."
echo ""

# Clean up any previous test entries
journalctl -t concurtest --vacuum-time=1s >/dev/null 2>&1

echo "Starting two concurrent loops (200 lines each)..."
echo ""

# Terminal 1 simulation (background)
(
    for i in $(seq 1 200); do
        echo "T1 line $i" | systemd-cat -t concurtest -p info
    done
) &
PID1=$!

# Terminal 2 simulation (background)
(
    for i in $(seq 1 200); do
        echo "T2 line $i" | systemd-cat -t concurtest -p info
    done
) &
PID2=$!

# Wait for both to complete
wait $PID1
wait $PID2

echo "✓ Both concurrent writers finished"
echo ""

# Give journald time to process
sleep 2

echo "Inspecting results: journalctl -t concurtest --no-pager | tail -n 50"
echo ""

JOURNAL_OUTPUT=$(journalctl -t concurtest --no-pager)
echo "$JOURNAL_OUTPUT" | tail -n 50

echo ""
echo "---"
echo ""

echo "Analysis: Checking for garbled/interleaved lines..."
echo ""

# Check for partial lines or mixed content
GARBLED=$(echo "$JOURNAL_OUTPUT" | grep -E "T1.*T2|T2.*T1")

if [ -z "$GARBLED" ]; then
    echo "✓ No garbled lines detected"
    echo "  Each line appears as a separate complete record"
    echo "  T1 and T2 lines are NOT mixed within single entries"
else
    echo "✗ GARBLED LINES FOUND:"
    echo "$GARBLED"
fi

echo ""

# Count total entries
TOTAL_LINES=$(echo "$JOURNAL_OUTPUT" | wc -l | tr -d ' ')
echo "Total journal entries for 'concurtest': $TOTAL_LINES"
echo "Expected: ~400 (200 from T1 + 200 from T2)"

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  You should see separate records for each line"
echo "  NOT partial line fragments mixed together within one line"
echo "  This would support the practical behavior claimed"
echo ""
echo "IMPORTANT NOTE from GPT document:"
echo "  'Because the manuals do not directly promise atomic/thread-safe"
echo "   in that exact wording, I would treat this as an empirical test"
echo "   rather than a settled documented fact'"
echo ""
echo "Claim tested:"
echo "  journald ensures log entries are written atomically"
echo ""
echo "Status: This claim is STRONGER than what manuals state"
echo "  Manuals say: journald handles multiple parallel log streams"
echo "  Manuals do NOT say: explicitly atomic or thread-safe"
echo ""
echo "=========================================="
echo "GPT Test 7 (R2) Complete"
echo "=========================================="
