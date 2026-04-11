#!/bin/bash
# Sync outputs back from Azure VM to local system

VM_USER="uridev"
VM_HOST="20.164.0.168"
SSH_KEY="~/.ssh/uridev.pem"
REMOTE_DIR="/home/uridev/task28_tests"

echo "=========================================="
echo "Syncing Outputs from Azure VM"
echo "=========================================="
echo ""

echo "VM: $VM_USER@$VM_HOST"
echo "Remote directory: $REMOTE_DIR/outputs"
echo ""

# Create local outputs directories if they don't exist
mkdir -p outputs/R1 outputs/R2

# Sync outputs from VM to local
echo "Syncing output files from VM..."
rsync -avz -e "ssh -i ~/.ssh/uridev.pem" \
    "$VM_USER@$VM_HOST:$REMOTE_DIR/outputs/" \
    /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/outputs/

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Outputs synced successfully"
    echo ""
    echo "Local outputs location:"
    echo "  /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/outputs/"
    echo ""
    echo "Files synced:"
    find /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/outputs/ -type f -name "*.txt" | sort
else
    echo ""
    echo "✗ Sync failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "Sync Complete"
echo "=========================================="
