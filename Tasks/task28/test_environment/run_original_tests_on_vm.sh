#!/bin/bash
# Run the original (non-GPT) test files on Azure VM

VM_USER="uridev"
VM_HOST="20.164.0.168"
REMOTE_DIR="/home/uridev/task28_tests"

echo "==========================================================================="
echo "Task 28 - Running Original (Non-GPT) Tests on VM"
echo "==========================================================================="
echo ""

# Step 1: Sync to VM (in case files were updated)
echo "Step 1: Syncing files to VM..."
./setup_and_sync_to_vm.sh

if [ $? -ne 0 ]; then
    echo "✗ Failed to sync to VM"
    exit 1
fi

echo ""
echo "==========================================================================="
echo ""

# Step 2: Run original tests on VM
echo "Step 2: Running original tests on VM..."
echo ""

ssh -i ~/.ssh/uridev.pem "$VM_USER@$VM_HOST" << 'ENDSSH'
cd /home/uridev/task28_tests

echo "========================================"
echo "Running R1 Original Tests (3 tests)"
echo "========================================"
echo ""

# R1 Test 1
echo "Running R1/test_R1_flock_example.sh..."
bash R1/test_R1_flock_example.sh 2>&1 | tee outputs/R1/test_R1_flock_example_output.txt
echo ""
echo "---"
echo ""

# R1 Test 2
echo "Running R1/test_R1_permissions_commands.sh..."
bash R1/test_R1_permissions_commands.sh 2>&1 | tee outputs/R1/test_R1_permissions_commands_output.txt
echo ""
echo "---"
echo ""

# R1 Test 3
echo "Running R1/test_R1_service_file_claims.sh..."
bash R1/test_R1_service_file_claims.sh 2>&1 | tee outputs/R1/test_R1_service_file_claims_output.txt
echo ""
echo "---"
echo ""

echo "========================================"
echo "Running R2 Original Tests (2 tests)"
echo "========================================"
echo ""

# R2 Test 1
echo "Running R2/test_R2_example_script.sh..."
bash R2/test_R2_example_script.sh 2>&1 | tee outputs/R2/test_R2_example_script_output.txt
echo ""
echo "---"
echo ""

# R2 Test 2
echo "Running R2/test_R2_logger_command.sh..."
bash R2/test_R2_logger_command.sh 2>&1 | tee outputs/R2/test_R2_logger_command_output.txt
echo ""
echo "---"
echo ""

echo "========================================"
echo "Running Shared Tests (1 test)"
echo "========================================"
echo ""

# Shared Test
echo "Running test_shared_atomicity.sh..."
bash test_shared_atomicity.sh 2>&1 | tee outputs/test_shared_atomicity_output.txt
echo ""

echo "All original tests complete!"

ENDSSH

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
echo "  ./outputs/"
echo ""
