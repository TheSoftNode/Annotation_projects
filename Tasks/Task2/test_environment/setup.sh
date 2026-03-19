#!/bin/bash

# Setup script for Task 2 Testing Environment
# This creates a virtual environment and installs all dependencies

echo "=========================================="
echo "Setting up Task 2 Testing Environment"
echo "=========================================="

# Navigate to the Task2 directory
cd "$(dirname "$0")"

echo ""
echo "Step 1: Creating Python virtual environment..."
python3 -m venv venv

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to create virtual environment"
    echo "Please ensure Python 3 is installed: python3 --version"
    exit 1
fi

echo "✓ Virtual environment created"

echo ""
echo "Step 2: Activating virtual environment..."
source venv/bin/activate

echo "✓ Virtual environment activated"

echo ""
echo "Step 3: Upgrading pip..."
pip install --upgrade pip --quiet

echo "✓ pip upgraded"

echo ""
echo "Step 4: Installing required packages..."
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install packages"
    exit 1
fi

echo "✓ All packages installed"

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "To activate the environment in the future, run:"
echo "  source venv/bin/activate"
echo ""
echo "To run the tests:"
echo "  python test_response1_code.py"
echo "  python test_response2_code.py"
echo ""
echo "To deactivate when done:"
echo "  deactivate"
echo ""
