#!/bin/bash
# GPT Factual Test 10: Verify chmod 6640 comment mismatch
# Tests R1's chmod 6640 command and its comment from section 3.2

echo "=========================================="
echo "GPT Test 10: chmod 6640 Comment Mismatch"
echo "=========================================="
echo ""

echo "This test verifies R1's chmod 6640 command and checks if the comment matches"
echo "Testing claim 21 about setuid/setgid bits"
echo ""

# Create test file
TEST_FILE="/tmp/test-log-permissions.log"
touch "$TEST_FILE"

echo "Test 1: Apply R1's exact chmod command"
echo ""

echo "Command from R1 Section 3.2:"
echo "  sudo chmod 6640 /var/log/myapp  # setuid + setgid + rw-r-----"
echo ""

echo "Applying: chmod 6640 $TEST_FILE"
sudo chmod 6640 "$TEST_FILE"

echo "✓ Command applied"
echo ""

# Test 2: Verify actual permissions
echo "Test 2: Inspect actual permissions"
echo ""

PERMS=$(ls -l "$TEST_FILE" | awk '{print $1}')
echo "Permissions from ls -l: $PERMS"
echo ""

# Test 3: Decode the permissions
echo "Test 3: Decode permissions in detail"
echo ""

echo "Octal 6640 breakdown:"
echo "  6 = setuid (4) + setgid (2) = Special bits"
echo "  6 = rw- (4+2+0) = Owner permissions"
echo "  4 = r-- (4+0+0) = Group permissions"
echo "  0 = --- (0+0+0) = Other permissions"
echo ""

echo "Expected symbolic: rwSr-S---"
echo "  rw- : Owner can read and write"
echo "  S   : Setuid bit set, but NOT executable (capital S)"
echo "  r-- : Group can read only"
echo "  S   : Setgid bit set, but NOT executable (capital S)"
echo "  --- : Others have no permissions"
echo ""

echo "Actual symbolic: $PERMS"
echo ""

# Test 4: Compare with R1's comment
echo "Test 4: Compare with R1's comment"
echo ""

echo "R1's comment says: '# setuid + setgid + rw-r-----'"
echo ""

R1_CLAIM="rw-r-----"
ACTUAL=$(echo "$PERMS" | cut -c2-10)

echo "R1 claims: $R1_CLAIM"
echo "Actual:    $ACTUAL"
echo ""

if [ "$ACTUAL" = "$R1_CLAIM" ]; then
    echo "✓ R1's comment matches reality"
else
    echo "✗ MISMATCH DETECTED"
    echo ""
    echo "Why the mismatch?"
    echo "  R1's comment: rw-r-----"
    echo "    This shows: owner=rw-, group=r--, other=---"
    echo ""
    echo "  Actual result: $ACTUAL"
    echo "    This shows: owner=rwS, group=r-S, other=---"
    echo ""
    echo "The comment IGNORES the setuid/setgid bits in symbolic notation"
    echo "  • Capital 'S' in owner position = setuid bit (no execute)"
    echo "  • Capital 'S' in group position = setgid bit (no execute)"
    echo ""
    echo "The comment should say: 'rwSr-S---' to be accurate"
fi

echo ""

# Test 5: Demonstrate the setuid/setgid bits
echo "Test 5: Verify setuid/setgid bits with stat"
echo ""

echo "Using stat to show full permission details:"
stat -c "Access: (%a/%A)" "$TEST_FILE" 2>/dev/null || stat -f "Permissions: %Lp" "$TEST_FILE"

echo ""

# Test 6: Explain the security implications
echo "---"
echo ""
echo "Security analysis of chmod 6640:"
echo ""
echo "What R1 intended:"
echo "  • Owner and group can read the log file"
echo "  • Owner can write to the log file"
echo "  • setgid ensures new entries inherit the group"
echo ""
echo "Unexpected behavior:"
echo "  • setuid bit (4) is SET"
echo "  • setuid on a NON-EXECUTABLE log file is unusual"
echo "  • Most log files only need setgid (2), not setuid (4)"
echo ""
echo "Correct command should probably be:"
echo "  sudo chmod 2640 /var/log/myapp  # setgid + rw-r-----"
echo "  (Using 2 instead of 6 to only set setgid)"
echo ""

# Cleanup
rm -f "$TEST_FILE"

echo "Expected result: R1's chmod 6640 works but comment is incomplete"
echo "The comment doesn't show the 'S' bits in symbolic notation"
echo ""
echo "=========================================="
echo "GPT Test 10 Complete"
echo "=========================================="
