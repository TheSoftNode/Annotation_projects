#!/bin/bash
# Test R1's flock example for shared log file safety

echo "========================================"
echo "R1: flock Example Test"
echo "========================================"
echo ""

LOGFILE="/tmp/flock-test-$$.log"
touch "$LOGFILE"

# Test R1-040: flock -n 200 || exit 1
# Test R1-041: 200>>"$logfile"

echo "Test R1-040, R1-041: flock usage for safe append"
echo "Testing R1's exact flock example..."

# R1's example code
(
    flock -n 200 || exit 1
    printf '%s [%s] %s\n' "$(date +%F_%T)" "$USER" "Test log entry" >> "$LOGFILE"
) 200>>"$LOGFILE"

if [ $? -eq 0 ]; then
    echo "✓ flock example executed successfully"
    echo "✓ Entry written to $LOGFILE:"
    cat "$LOGFILE"
else
    echo "✗ flock example failed"
fi

# Test concurrent flock (one should block/fail)
echo ""
echo "Testing flock prevents concurrent writes..."

(
    flock -n 200 || exit 1
    sleep 2
    echo "Long write 1" >> "$LOGFILE"
) 200>>"$LOGFILE" &
PID1=$!

sleep 0.5

(
    flock -n 200 || { echo "✓ Second writer blocked as expected"; exit 1; }
    echo "Long write 2" >> "$LOGFILE"
) 200>>"$LOGFILE"
RESULT=$?

wait $PID1

if [ $RESULT -ne 0 ]; then
    echo "✓ flock correctly prevents concurrent writes"
else
    echo "⚠ Both writes succeeded (unexpected)"
fi

rm -f "$LOGFILE"

echo ""
echo "========================================"
echo "R1 flock Tests Complete"
echo "========================================"
