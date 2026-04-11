#!/bin/bash
# Complete automation: sync to VM, run tests, sync outputs back

VM_USER="uridev"
VM_HOST="20.164.0.168"
REMOTE_DIR="/home/uridev/task28_tests"

echo "==========================================================================="
echo "Task 28 - Automated VM Testing"
echo "==========================================================================="
echo ""

# Step 1: Sync to VM
echo "Step 1: Syncing files to Azure VM..."
./setup_and_sync_to_vm.sh

if [ $? -ne 0 ]; then
    echo "✗ Failed to sync to VM"
    exit 1
fi

echo ""
echo "==========================================================================="
echo ""

# Step 2: Run tests on VM
echo "Step 2: Running all tests on VM..."
echo ""

ssh -i ~/.ssh/uridev.pem "$VM_USER@$VM_HOST" "cd $REMOTE_DIR && ./run_all_GPT_tests_with_output.sh"

if [ $? -ne 0 ]; then
    echo ""
    echo "⚠ Tests completed with errors"
else
    echo ""
    echo "✓ Tests completed successfully"
fi

echo ""
echo "==========================================================================="
echo ""

# Step 3: Sync outputs back
echo "Step 3: Syncing outputs back from VM..."
./sync_outputs_from_vm.sh

if [ $? -ne 0 ]; then
    echo "✗ Failed to sync outputs"
    exit 1
fi

echo ""
echo "==========================================================================="
echo "Complete!"
echo "==========================================================================="
echo ""
echo "Output files are in:"
echo "  ./outputs/R1/"
echo "  ./outputs/R2/"
echo ""
echo "To view outputs:"
echo "  ls -la outputs/R1/"
echo "  ls -la outputs/R2/"
echo "  cat outputs/R1/GPT_test_01_basic_systemd_cat_output.txt"
echo ""
