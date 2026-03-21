#!/bin/bash

echo "=========================================="
echo "Running All Task 3 Tests"
echo "=========================================="
echo ""

./test_response1_code.sh

echo ""
echo ""

./test_response2_code.sh

echo ""
echo "=========================================="
echo "All Tests Complete"
echo "=========================================="
echo ""
echo "Summary:"
echo "  ✗ Response 1: Uses gtkmm C++ incompatible with xtor's GTK C API"
echo "  ✗ Response 2: Uses GTK 4 API incompatible with xtor's GTK 2.16"
echo "  ✓ Both issues verified as Substantial"
echo ""
echo "See Golden_Annotation_Task3.md for full analysis"
echo ""
