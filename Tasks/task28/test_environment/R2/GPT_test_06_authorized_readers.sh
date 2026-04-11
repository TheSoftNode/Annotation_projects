#!/bin/bash
# GPT Factual Test 6 (R2): Verify the "authorized readers" claim
# Tests R2's Code Test 6 from GPT_FACTUAL_R2_TASK28.md (lines 336-349)

echo "=========================================="
echo "GPT Test 6 (R2): Authorized Readers Test"
echo "=========================================="
echo ""

echo "Testing R2's claim about access controls:"
echo "  'Only authorized users (typically root or members of"
echo "   systemd-journal group) can read logs'"
echo ""

echo "Test 1: Current user's access to journal"
echo ""

echo "Running as current user ($USER):"
echo "journalctl -n 5 --no-pager"
echo ""

journalctl -n 5 --no-pager 2>&1
NORMAL_EXIT=$?

if [ $NORMAL_EXIT -eq 0 ]; then
    echo ""
    echo "✓ Current user CAN read journal entries"
    echo "  (May be limited to own entries or user has group membership)"
else
    echo ""
    echo "✗ Current user CANNOT read journal entries"
    echo "  Access denied - needs special permissions"
fi

echo ""
echo "---"
echo ""

echo "Test 2: Root user's access to journal"
echo ""

echo "Running as root:"
echo "sudo journalctl -n 5 --no-pager"
echo ""

sudo journalctl -n 5 --no-pager 2>&1
ROOT_EXIT=$?

if [ $ROOT_EXIT -eq 0 ]; then
    echo ""
    echo "✓ Root CAN read journal entries"
else
    echo ""
    echo "✗ Root CANNOT read journal entries (unexpected)"
fi

echo ""
echo "---"
echo ""

echo "Test 3: Check current user's group memberships"
echo ""

echo "Current user's groups:"
groups

echo ""

if groups | grep -qE 'systemd-journal|adm|wheel'; then
    echo "✓ User is member of journal-reading group(s)"
    groups | grep -oE 'systemd-journal|adm|wheel' | while read grp; do
        echo "  • $grp"
    done
else
    echo "⊘ User is NOT in systemd-journal, adm, or wheel groups"
    echo "  This may limit journal access"
fi

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  On many systems, normal user will NOT read full system journal"
echo "  Root WILL be able to read it"
echo "  Exact behavior depends on group membership and config"
echo ""
echo "Manual says: By default only root and members of"
echo "  systemd-journal, adm, and wheel can read all journal files"
echo ""
echo "Claims tested:"
echo "  • Only authorized users can read logs"
echo "  • Typically root or members of systemd-journal group"
echo ""
echo "Note: R2's claim is MOSTLY CORRECT but incomplete"
echo "  It mentions root and systemd-journal"
echo "  But docs also include 'adm' and 'wheel' groups"
echo ""
echo "=========================================="
echo "GPT Test 6 (R2) Complete"
echo "=========================================="
