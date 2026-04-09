#!/bin/bash

echo "=========================================="
echo "R2 - ALL AOI TESTS"
echo "=========================================="
echo ""
echo "This script runs all R2 AOI verification tests"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$SCRIPT_DIR/../outputs/R2"

mkdir -p "$OUTPUT_DIR"

echo "Installing kernel headers if needed..."
if [ ! -d "/lib/modules/$(uname -r)/build" ]; then
    sudo apt-get update
    sudo apt-get install -y linux-headers-$(uname -r)
fi

echo ""
echo "=========================================="
echo "TEST 1: AOI #2 - Missing module_exit"
echo "=========================================="
echo ""

chmod +x test_aoi2_missing_module_exit.sh
./test_aoi2_missing_module_exit.sh 2>&1 | tee "$OUTPUT_DIR/aoi2_missing_module_exit.txt"

echo ""
echo "=========================================="
echo "TEST 2: AOI #5 - Missing INIT_WORK"
echo "=========================================="
echo ""

chmod +x test_aoi5_missing_init_work.sh
./test_aoi5_missing_init_work.sh 2>&1 | tee "$OUTPUT_DIR/aoi5_missing_init_work.txt"

echo ""
echo "=========================================="
echo "ALL TESTS COMPLETE"
echo "=========================================="
echo ""
echo "Results saved to:"
echo "  - $OUTPUT_DIR/aoi2_missing_module_exit.txt"
echo "  - $OUTPUT_DIR/aoi5_missing_init_work.txt"
echo ""
