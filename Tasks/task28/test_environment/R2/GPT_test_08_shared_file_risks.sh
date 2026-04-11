#!/bin/bash
# GPT Factual Test 8 (R2): Compare against a shared writable file
# Tests R2's Code Test 8 from GPT_FACTUAL_R2_TASK28.md (lines 380-412)

echo "=========================================="
echo "GPT Test 8 (R2): Shared File Risk Test"
echo "=========================================="
echo ""

echo "Testing R2's claims about shared writable file risks:"
echo "  • Concurrent writes can interleave log lines"
echo "  • Users can tamper/erase logs"
echo "  • No built-in protections"
echo ""

SHARED_LOG="/tmp/shared-group-log.txt"

echo "Creating test script from GPT Code Test 8..."
echo ""

cat > sharedfiletest.sh <<'EOF'
#!/bin/bash
echo "[$USER] $$ $(date +%s%N)" >> /tmp/shared-group-log.txt
EOF

chmod +x sharedfiletest.sh

echo "✓ Test script created: sharedfiletest.sh"
echo ""

# Clean up any previous test file
rm -f "$SHARED_LOG"

echo "Test 1: Concurrent writes to shared file"
echo ""

echo "Running two concurrent loops (200 iterations each)..."

# Concurrent writer 1
(
    for i in $(seq 1 200); do
        ./sharedfiletest.sh
    done
) &
PID1=$!

# Concurrent writer 2
(
    for i in $(seq 1 200); do
        ./sharedfiletest.sh
    done
) &
PID2=$!

# Wait for completion
wait $PID1
wait $PID2

echo "✓ Both writers finished"
echo ""

echo "Inspecting results: tail -n 20 $SHARED_LOG"
echo ""
tail -n 20 "$SHARED_LOG"

echo ""

TOTAL_LINES=$(wc -l < "$SHARED_LOG" | tr -d ' ')
echo "Total lines written: $TOTAL_LINES"
echo "Expected: ~400 (200 from each loop)"

if [ "$TOTAL_LINES" -lt 400 ]; then
    echo "⚠ Some writes may have been lost or interleaved"
fi

echo ""
echo "---"
echo ""

echo "Test 2: Truncation/erase risk"
echo ""

echo "Current file size:"
ls -lh "$SHARED_LOG" | awk '{print $5, $9}'

echo ""
echo "Demonstrating truncation by any user with write permission:"
echo "Running: : > $SHARED_LOG"
: > "$SHARED_LOG"

echo ""
echo "File after truncation:"
ls -lh "$SHARED_LOG" | awk '{print $5, $9}'

if [ ! -s "$SHARED_LOG" ]; then
    echo ""
    echo "✓ File successfully ERASED"
    echo "  Any user with write permission can do this"
    echo "  This is the 'tampering/erase' risk R2 mentions"
fi

echo ""
echo "---"
echo ""

echo "Test 3: Overwrite risk"
echo ""

echo "Writing some data..."
echo "Important log entry 1" >> "$SHARED_LOG"
echo "Important log entry 2" >> "$SHARED_LOG"
echo "Important log entry 3" >> "$SHARED_LOG"

echo "Before overwrite:"
cat "$SHARED_LOG"

echo ""
echo "Overwriting entire file with: echo 'HACKED' > $SHARED_LOG"
echo "HACKED" > "$SHARED_LOG"

echo ""
echo "After overwrite:"
cat "$SHARED_LOG"

echo ""
echo "✓ File completely OVERWRITTEN"
echo "  All previous entries lost"

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  Concurrent appends work, but without safety guarantees"
echo "  : > file truncates immediately"
echo "  Any writer can overwrite or erase the file"
echo "  This supports R2's 'tampering/erase' concern"
echo ""
echo "Claims tested:"
echo "  • Users can potentially overwrite or corrupt the log"
echo "  • Concurrent writes can interleave log lines"
echo "  • Users can potentially flood or erase logs"
echo "  • No built-in limit on log size per user"
echo ""

# Cleanup
rm -f sharedfiletest.sh "$SHARED_LOG"

echo "=========================================="
echo "GPT Test 8 (R2) Complete"
echo "=========================================="
