#!/bin/bash
# Step J: Check whether "same work item will not run concurrently with itself" claim is plausible
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step J: Verify concurrent execution claim"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -d "Documentation" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find 'same work item cannot be queued twice'"
echo "------------------------------------------------------------"
grep -R -n "same work item cannot be queued twice" .
echo

echo "Test 2: Find 'avoid executing the same work item concurrently'"
echo "------------------------------------------------------------"
grep -R -n "avoid executing the same work item concurrently" .
echo

echo "============================================================"
echo "What this tests:"
echo "  - R2 Claim: 'The same work item will not run concurrently with itself'"
echo ""
echo "Note: Depending on tree snapshot, you may or may not get hits"
echo "      If no hits, use documented header behavior from Steps B-F"
echo "      plus cited changelog evidence rather than treating absence"
echo "      of grep hit as disproof."
echo "============================================================"
