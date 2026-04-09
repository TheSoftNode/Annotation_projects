#!/bin/bash
# Step H: Verify the "can sleep / can take mutexes" part
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step H: Verify sleep and mutex capability"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -d "Documentation" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find documentation about mutex and sleep in process context"
echo "------------------------------------------------------------"
grep -R -n "use a mutex. You can take a mutex and sleep" Documentation
echo

echo "Test 2: Find workqueue mentioned in sleep-capable contexts"
echo "------------------------------------------------------------"
grep -R -n "such as a workqueue" Documentation | head -20
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'Sleep (schedule(), msleep(), etc.)'"
echo "  - 'Take mutexes and other sleeping locks'"
echo "============================================================"
