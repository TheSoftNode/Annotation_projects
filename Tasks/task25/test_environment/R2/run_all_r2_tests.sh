#!/bin/bash
# Master test runner for R2 kernel header verification
# Must be run in GitHub Codespaces from Linux kernel source root

echo "============================================================"
echo "R2 KERNEL HEADER VERIFICATION - ALL STEPS"
echo "WARNING: R2 is OFF-TOPIC (answers schedule_work, not floats)"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo ""
    echo "Setup instructions:"
    echo "  1. Open GitHub Codespaces"
    echo "  2. Run the following commands:"
    echo ""
    echo "  sudo apt update"
    echo "  sudo apt install -y git build-essential bc flex bison libelf-dev libssl-dev"
    echo "  git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
    echo "  cd linux"
    echo ""
    echo "  3. Copy R2 test scripts to linux/ directory"
    echo "  4. Run this script again"
    echo ""
    exit 1
fi

echo "Kernel source detected. Running all verification steps..."
echo

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run all steps
for step in B C D E F G H I J; do
    if [ -f "${SCRIPT_DIR}/test_step_${step}_"*.sh ]; then
        TEST_SCRIPT=$(ls "${SCRIPT_DIR}/test_step_${step}_"*.sh)
        echo
        echo "========================================================"
        echo "Running Step $step"
        echo "========================================================"
        bash "$TEST_SCRIPT"
    fi
done

echo
echo "============================================================"
echo "ALL R2 VERIFICATION STEPS COMPLETE"
echo "============================================================"
echo
echo "Key findings expected:"
echo "  1. R2 is completely OFF-TOPIC (answers wrong question)"
echo "  2. flush_scheduled_work() has deadlock warnings (R2 doesn't mention)"
echo "  3. User-space memory claim is SUSPICIOUS"
echo "  4. to_delayed_work() usage in snippet is questionable"
echo "============================================================"
