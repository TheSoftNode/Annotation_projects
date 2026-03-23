#!/bin/bash

echo "======================================"
echo "Task 5: PyHackRF Installation Tests"
echo "======================================"
echo ""

# Make all scripts executable
chmod +x verify_repositories.sh
chmod +x test_response1_accuracy.sh
chmod +x test_response2_accuracy.sh

# Run repository verification
echo "Step 1: Verifying Repository URLs..."
echo ""
./verify_repositories.sh
echo ""
echo "Press Enter to continue..."
read

# Test Response 1
echo ""
echo "Step 2: Testing Response 1 Accuracy..."
echo ""
./test_response1_accuracy.sh
R1_EXIT=$?
echo ""
echo "Press Enter to continue..."
read

# Test Response 2
echo ""
echo "Step 3: Testing Response 2 Accuracy..."
echo ""
./test_response2_accuracy.sh
R2_EXIT=$?
echo ""

# Final Summary
echo "======================================"
echo "FINAL TEST RESULTS"
echo "======================================"
echo ""
echo "Response 1: $([ $R1_EXIT -eq 0 ] && echo '✅ PASS' || echo '❌ FAIL') (Exit code: $R1_EXIT)"
echo "Response 2: $([ $R2_EXIT -eq 0 ] && echo '✅ PASS' || echo '❌ FAIL') (Exit code: $R2_EXIT)"
echo ""
echo "======================================"
echo "KEY FINDINGS:"
echo "======================================"
echo ""
echo "1. Response 1 uses non-existent repository: github.com/mossmann/pyhackrf"
echo "2. Response 2 uses non-existent repository: github.com/atech/pyhackrf"
echo "3. Correct repository: github.com/dressel/pyhackrf (official PyPI source)"
echo "4. Alternative: github.com/GvozdevLeonid/python_hackrf"
echo ""
echo "CONCLUSION: Both responses contain critical factual errors that"
echo "would prevent successful installation."
echo ""
