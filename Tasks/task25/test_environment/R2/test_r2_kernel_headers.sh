#!/bin/bash
# Test R2 kernel header claims from R2_GPT_Factual_Task25.md
# NOTE: R2 is OFF-TOPIC (answers about Linux kernel workqueue instead of floats)
# This script verifies the technical claims R2 makes about kernel APIs

echo "============================================================"
echo "R2 Kernel Header Verification"
echo "WARNING: R2 is OFF-TOPIC - it answers about schedule_work()"
echo "         instead of the float vs integer question"
echo "============================================================"
echo

# Check if we're in Codespaces
if [ -z "$CODESPACES" ]; then
    echo "WARNING: This test should be run in GitHub Codespaces"
    echo "         as specified in R2_GPT_Factual_Task25.md"
    echo
fi

echo "Step B: Verify linux/workqueue.h exists"
echo "------------------------------------------------------------"
if [ -f "/usr/include/linux/workqueue.h" ]; then
    echo "FOUND: /usr/include/linux/workqueue.h"
else
    echo "NOT FOUND: /usr/include/linux/workqueue.h"
    echo "Attempting to find workqueue.h in kernel headers..."
    find /usr/src /lib/modules -name "workqueue.h" 2>/dev/null | head -5
fi
echo

echo "Step C: Check for schedule_work definition"
echo "------------------------------------------------------------"
echo "Searching for 'schedule_work' in kernel headers..."
if grep -r "schedule_work" /usr/include/linux/ 2>/dev/null | head -3; then
    echo "Found references to schedule_work"
else
    echo "No direct references found in /usr/include/linux/"
    echo "May need kernel source tree for full verification"
fi
echo

echo "Step D: Check for INIT_WORK macro"
echo "------------------------------------------------------------"
echo "Searching for 'INIT_WORK' in kernel headers..."
if grep -r "INIT_WORK" /usr/include/linux/ 2>/dev/null | head -3; then
    echo "Found INIT_WORK macro"
else
    echo "INIT_WORK not found in user-space headers"
fi
echo

echo "Step E: Check for work_struct definition"
echo "------------------------------------------------------------"
echo "Searching for 'struct work_struct' in kernel headers..."
if grep -r "struct work_struct" /usr/include/linux/ 2>/dev/null | head -3; then
    echo "Found work_struct definition"
else
    echo "work_struct not found in user-space headers"
fi
echo

echo "Step F: Verify system_wq vs system_percpu_wq claim"
echo "------------------------------------------------------------"
echo "R2 claims schedule_work uses system_wq"
echo "Checking kernel documentation for actual workqueue..."
echo "(This requires kernel source - will check if available)"
echo

if [ -d "/workspaces/linux" ]; then
    echo "Found Linux kernel source at /workspaces/linux"
    grep -A 5 "static inline.*schedule_work" /workspaces/linux/include/linux/workqueue.h
elif [ -d "$HOME/linux" ]; then
    echo "Found Linux kernel source at $HOME/linux"
    grep -A 5 "static inline.*schedule_work" $HOME/linux/include/linux/workqueue.h
else
    echo "Kernel source not found - cannot verify"
    echo "R2 claim: Uses system_wq"
    echo "Expected: Uses system_percpu_wq (per Task 24 findings)"
fi
echo

echo "Step G: Check flush_scheduled_work deprecation"
echo "------------------------------------------------------------"
echo "Searching for flush_scheduled_work..."
if grep -r "flush_scheduled_work" /usr/include/linux/ 2>/dev/null; then
    echo "Found flush_scheduled_work references"
else
    echo "Not found in user-space headers"
fi
echo

echo "Step H: Verify process context claim"
echo "------------------------------------------------------------"
echo "R2 claims workqueues run in process context"
echo "This is a conceptual claim - verified through kernel documentation"
echo "Expected: TRUE - workqueues do run in process context"
echo

echo "Step I: Check user-space memory access claim"
echo "------------------------------------------------------------"
echo "R2 Claim 30: 'Access user-space memory (with copy_to_user)'"
echo "This is SUSPICIOUS - workqueues typically handle kernel-side work"
echo "User-space access requires proper context and is not a primary use case"
echo

echo "Step J: Summary of R2 verification"
echo "------------------------------------------------------------"
echo "Key findings:"
echo "1. R2 is completely OFF-TOPIC (answers wrong question)"
echo "2. R2 claims system_wq (likely wrong - should be system_percpu_wq)"
echo "3. R2 mentions flush_scheduled_work (deprecated API)"
echo "4. R2's user-space memory claim is suspicious"
echo

echo "============================================================"
echo "R2 Kernel Header Verification Complete"
echo "============================================================"
