#!/bin/bash
# GPT Factual Test 4: Verify the flock snippet
# Tests claim 20: flock -n 200 || exit 1 acquires exclusive lock

echo "=========================================="
echo "GPT Test 4: flock Snippet Verification"
echo "=========================================="
echo ""

echo "Creating EXACT flock test script from GPT Factual..."

cat > /tmp/flock_test.sh <<'EOF'
#!/usr/bin/env bash
logfile="/tmp/group-log.txt"
(
    flock -n 200 || exit 1
    printf '%s [%s] %s\n' "$(date +%F_%T)" "$USER" "$(cat)" >> "$logfile"
) 200>>"$logfile"
EOF

chmod +x /tmp/flock_test.sh

echo "✓ Test script created: /tmp/flock_test.sh"
echo ""

# Clean log file
rm -f /tmp/group-log.txt

# Test 1: Normal append
echo "Test 1: Normal append (no contention)"
printf 'one\n' | /tmp/flock_test.sh
if [ $? -eq 0 ]; then
    echo "✓ First write succeeded"
else
    echo "✗ First write failed"
fi

printf 'two\n' | /tmp/flock_test.sh
if [ $? -eq 0 ]; then
    echo "✓ Second write succeeded"
else
    echo "✗ Second write failed"
fi

echo ""
echo "Log file contents:"
cat /tmp/group-log.txt
echo ""

# Test 2: Lock conflict test
echo "Creating lock-hold script for conflict test..."

cat > /tmp/flock_lockhold.sh <<'EOF'
#!/usr/bin/env bash
logfile="/tmp/group-log.txt"
(
    flock -n 200 || exit 1
    sleep 10
    printf '%s [%s] hold\n' "$(date +%F_%T)" "$USER" >> "$logfile"
) 200>>"$logfile"
EOF

chmod +x /tmp/flock_lockhold.sh

echo "✓ Lock-hold script created"
echo ""
echo "Test 2: Lock conflict (nonblocking behavior)"
echo "Starting long-hold process in background..."

/tmp/flock_lockhold.sh &
BGPID=$!

sleep 1

echo "Attempting second write while lock is held..."
/tmp/flock_lockhold.sh 2>/dev/null
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "✓ CONFIRMED: Second process failed to acquire lock (exit code: $RESULT)"
    echo "  This proves 'flock -n' is nonblocking as documented"
else
    echo "✗ UNEXPECTED: Second process acquired lock (should have failed)"
fi

# Kill background process
kill $BGPID 2>/dev/null
wait $BGPID 2>/dev/null

echo ""
echo "Final log file:"
cat /tmp/group-log.txt
echo ""

# Cleanup
rm -f /tmp/flock_test.sh /tmp/flock_lockhold.sh /tmp/group-log.txt

echo "Expected result: -n makes flock nonblocking, second process exits immediately"
echo "This tests claim 20: flock manages locks, -n is nonblocking, exclusive is default"
echo ""
echo "=========================================="
echo "GPT Test 4 Complete"
echo "=========================================="
