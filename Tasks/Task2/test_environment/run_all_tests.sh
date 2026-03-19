#!/bin/bash

# Run all tests script
# This activates the virtual environment and runs both test files

echo "=========================================="
echo "Running All Task 2 Tests"
echo "=========================================="

# Navigate to script directory
cd "$(dirname "$0")"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

echo ""
echo "=========================================="
echo "TEST 1: Response 1 Code"
echo "=========================================="
python test_response1_code.py

echo ""
echo ""
echo "=========================================="
echo "TEST 2: Response 2 Code"
echo "=========================================="
python test_response2_code.py

echo ""
echo "=========================================="
echo "All Tests Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  Response 1: ✓ Working code with minor issues (Score: 4)"
echo "  Response 2: ✗ Critical logic error (Score: 2)"
echo ""
echo "See output above for detailed results."
echo ""

deactivate
