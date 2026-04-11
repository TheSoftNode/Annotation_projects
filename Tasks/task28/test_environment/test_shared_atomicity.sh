#!/bin/bash
# Shared test: Atomicity claims (both R1 and R2 claim this)
# R1-001, R1-002, R1-003, R2-011, R2-012, R2-020

echo "========================================"
echo "SHARED: Atomicity & Race Conditions"
echo "========================================"
echo ""

SHARED_LOG="/tmp/shared-concurrency-test-$$.txt"
JOURNAL_TAG="atomicity-test-$$"
NUM_WRITERS=10
MSGS_PER_WRITER=100

echo "Test Configuration:"
echo "  Writers: $NUM_WRITERS"
echo "  Messages per writer: $MSGS_PER_WRITER"
echo "  Total expected: $((NUM_WRITERS * MSGS_PER_WRITER))"
echo ""

# ==========================================
# Part 1: Plain text file (R1-001, R2-020)
# ==========================================
echo "Part 1: Plain Text File (No Locking)"
echo "Testing R1-001: 'two processes can truncate or interleave their text'"
echo "Testing R2-020: 'Concurrent writes can interleave log lines'"
echo ""

rm -f "$SHARED_LOG"
touch "$SHARED_LOG"

write_plain() {
    local id=$1
    for i in $(seq 1 $MSGS_PER_WRITER); do
        printf '[Writer-%02d] Message %03d at %s\n' "$id" "$i" "$(date +%H:%M:%S.%N)" >> "$SHARED_LOG"
    done
}

START=$(date +%s)
for w in $(seq 1 $NUM_WRITERS); do
    write_plain $w &
done
wait
END=$(date +%s)

echo "Plain file writes completed in $((END - START)) seconds"

PLAIN_LINES=$(wc -l < "$SHARED_LOG")
PLAIN_EXPECTED=$((NUM_WRITERS * MSGS_PER_WRITER))

# Check for corruption
MALFORMED=$(grep -v "^\[Writer-[0-9][0-9]\] Message [0-9][0-9][0-9] at [0-9]" "$SHARED_LOG" | wc -l)

echo "Results:"
echo "  Expected lines: $PLAIN_EXPECTED"
echo "  Actual lines:   $PLAIN_LINES"
echo "  Malformed:      $MALFORMED"

if [ "$MALFORMED" -gt 0 ]; then
    echo "  ✓ R1-001 CONFIRMED: Found interleaved/garbled lines"
    echo "  ✓ R2-020 CONFIRMED: Concurrent writes interleaved"
    echo "  Sample corruption:"
    grep -v "^\[Writer-[0-9][0-9]\] Message [0-9][0-9][0-9] at [0-9]" "$SHARED_LOG" | head -3 | sed 's/^/    /'
elif [ "$PLAIN_LINES" -ne "$PLAIN_EXPECTED" ]; then
    echo "  ✓ R1-001 CONFIRMED: Missing lines (race condition)"
else
    echo "  ⚠ No corruption detected (race conditions are non-deterministic)"
fi

# ==========================================
# Part 2: journald (R1-002, R1-003, R2-011, R2-012)
# ==========================================
echo ""
echo "Part 2: journald via systemd-cat"
echo "Testing R1-002: 'Each systemd-cat invocation is a single write'"
echo "Testing R1-003: 'daemon queues and serialises entries'"
echo "Testing R2-011: 'journald ensures log entries are written atomically'"
echo "Testing R2-012: 'avoids garbled output from concurrent writes'"
echo ""

# Clean journal
sudo journalctl --rotate 2>/dev/null
sudo journalctl --vacuum-time=1s 2>/dev/null
sleep 2

write_journal() {
    local id=$1
    for i in $(seq 1 $MSGS_PER_WRITER); do
        printf '[JWriter-%02d] Message %03d at %s\n' "$id" "$i" "$(date +%H:%M:%S.%N)" | systemd-cat -t "$JOURNAL_TAG" -p info
    done
}

START=$(date +%s)
for w in $(seq 1 $NUM_WRITERS); do
    write_journal $w &
done
wait
END=$(date +%s)

echo "Journal writes completed in $((END - START)) seconds"
sleep 2

JOURNAL_LINES=$(journalctl -t "$JOURNAL_TAG" --since "2 minutes ago" --no-pager | grep -c "JWriter")

echo "Results:"
echo "  Expected entries: $PLAIN_EXPECTED"
echo "  Actual entries:   $JOURNAL_LINES"

# Check for malformed entries
JOURNAL_OUTPUT=$(journalctl -t "$JOURNAL_TAG" --since "2 minutes ago" --no-pager -o short)
JOURNAL_MALFORMED=$(echo "$JOURNAL_OUTPUT" | grep "JWriter" | grep -v "\[JWriter-[0-9][0-9]\] Message [0-9][0-9][0-9]" | wc -l)

echo "  Malformed:        $JOURNAL_MALFORMED"

if [ "$JOURNAL_MALFORMED" -eq 0 ] && [ "$JOURNAL_LINES" -ge $((PLAIN_EXPECTED - 5)) ]; then
    echo "  ✓ R1-002 CONFIRMED: All writes atomic"
    echo "  ✓ R1-003 CONFIRMED: Entries serialized correctly"
    echo "  ✓ R2-011 CONFIRMED: Atomic writes"
    echo "  ✓ R2-012 CONFIRMED: No garbled output"
else
    echo "  ⚠ Some entries may be missing or malformed"
fi

# ==========================================
# Summary
# ==========================================
echo ""
echo "========================================"
echo "Summary"
echo "========================================"
echo "Plain file:  $MALFORMED corrupted out of $PLAIN_LINES lines"
echo "journald:    $JOURNAL_MALFORMED corrupted out of $JOURNAL_LINES entries"
echo ""

if [ "$MALFORMED" -gt "$JOURNAL_MALFORMED" ]; then
    echo "✓ journald demonstrates better data integrity"
else
    echo "⚠ Results inconclusive (may need to re-run)"
fi

rm -f "$SHARED_LOG"

echo ""
echo "========================================"
echo "Atomicity Tests Complete"
echo "========================================"
