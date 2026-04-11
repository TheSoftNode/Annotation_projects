#!/bin/bash
# Setup and sync test_environment to Azure VM

VM_USER="uridev"
VM_HOST="20.164.0.168"
SSH_KEY="~/.ssh/uridev.pem"
REMOTE_DIR="/home/uridev/task28_tests"

echo "=========================================="
echo "Syncing Task 28 Tests to Azure VM"
echo "=========================================="
echo ""

echo "VM: $VM_USER@$VM_HOST"
echo "Remote directory: $REMOTE_DIR"
echo ""

# Create outputs directories locally first
echo "Creating local outputs directories..."
mkdir -p outputs/R1 outputs/R2

echo "✓ Local directories created"
echo ""

# Sync to VM using rsync
echo "Syncing files to VM..."
rsync -avz -e "ssh -i ~/.ssh/uridev.pem" \
    --exclude '.DS_Store' \
    --exclude 'outputs/*' \
    /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/ \
    "$VM_USER@$VM_HOST:$REMOTE_DIR/"

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Files synced successfully"
else
    echo ""
    echo "✗ Sync failed"
    exit 1
fi

echo ""
echo "Creating outputs directories on VM..."
ssh -i ~/.ssh/uridev.pem "$VM_USER@$VM_HOST" "mkdir -p $REMOTE_DIR/outputs/R1 $REMOTE_DIR/outputs/R2"

echo "✓ Remote directories created"
echo ""

echo "=========================================="
echo "Setup Complete"
echo "=========================================="
echo ""
echo "To connect to VM and run tests:"
echo "  ssh -i ~/.ssh/uridev.pem $VM_USER@$VM_HOST"
echo "  cd $REMOTE_DIR"
echo "  ./run_all_GPT_tests_with_output.sh"
echo ""
echo "To sync outputs back to local:"
echo "  ./sync_outputs_from_vm.sh"
echo ""
