#!/bin/bash
# GPT Factual Test 3: Prove -u is unit-based, not user-based
# Tests claims 15, 16: Response's "journalctl -u alice" and "-u $USER" examples are misleading

echo "=========================================="
echo "GPT Test 3: -u is Unit-Based, NOT User-Based"
echo "=========================================="
echo ""

echo "Testing R1's claim that 'journalctl -u alice' shows alice's logs..."
echo ""

# Command 1
echo "Command 1: journalctl -u \"\$USER\" -n 20 --no-pager"
echo "Running: journalctl -u \"$USER\" -n 20 --no-pager"
OUTPUT1=$(journalctl -u "$USER" -n 20 --no-pager 2>&1)

echo "$OUTPUT1"
echo ""

if echo "$OUTPUT1" | grep -qi "no entries\|no journal files"; then
    echo "✓ CONFIRMED: No unit named '$USER' exists"
    echo "  This proves -u is a UNIT filter, not a USER filter"
elif echo "$OUTPUT1" | grep -qi "$USER.service"; then
    echo "⚠ A unit named '$USER.service' actually exists on this system"
    echo "  But this is coincidental, not intentional user filtering"
else
    echo "⚠ Unexpected output"
fi

echo ""
echo "---"
echo ""

# Command 2
echo "Command 2: journalctl --user-unit \"\$USER\" -n 20 --no-pager"
echo "Running: journalctl --user-unit \"$USER\" -n 20 --no-pager"
OUTPUT2=$(journalctl --user-unit "$USER" -n 20 --no-pager 2>&1)

echo "$OUTPUT2"
echo ""

if echo "$OUTPUT2" | grep -qi "no entries\|no journal files"; then
    echo "✓ CONFIRMED: No user-unit named '$USER' exists"
    echo "  This proves --user-unit is also a UNIT filter"
else
    echo "⚠ Unexpected output"
fi

echo ""
echo "Expected result: These commands only work if a unit is literally named \$USER"
echo "This DISPROVES R1's claims 15 & 16:"
echo "  - 'journalctl -t group-log -u alice' (R1 claim 15)"
echo "  - 'journalctl -t group-logger -u \$USER' (R1 claim 16)"
echo ""
echo "The correct way to filter by user is: journalctl _UID=\$UID"
echo ""
echo "=========================================="
echo "GPT Test 3 Complete"
echo "=========================================="
