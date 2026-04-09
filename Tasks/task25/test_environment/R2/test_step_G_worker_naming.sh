#!/bin/bash
# Step G: Verify worker naming
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step G: Verify worker naming (kworker/*)"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -d "Documentation" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test: Find kworker naming pattern in Documentation"
echo "------------------------------------------------------------"
grep -R -n "kworker/%u:%d%s" Documentation
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'Worker threads are named kworker/*'"
echo "============================================================"
