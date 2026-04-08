#!/bin/bash

echo "=== Testing R1 ==="

# Compile
gcc r1_main.c -o r1_main 2>&1
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi
echo "Compilation successful"
echo ""

# Test 1: Run with default hardcoded path
echo "Test 1: Run with hardcoded path /path/to/your/directory"
./r1_main
echo ""

# Test 2: Check if it handles existing directory
echo "Test 2: Create test directory and run again"
mkdir -p /tmp/test_r1_dir
# Modify code to use /tmp/test_r1_dir
sed 's|/path/to/your/directory|/tmp/test_r1_dir|g' r1_main.c > r1_main_modified.c
gcc r1_main_modified.c -o r1_main_modified 2>&1
./r1_main_modified
echo ""

# Test 3: Check if file was created
echo "Test 3: Verify file creation"
if [ -f "/tmp/test_r1_dir/newfile.txt" ]; then
    echo "File exists"
    cat /tmp/test_r1_dir/newfile.txt
else
    echo "File not found"
fi
echo ""

# Cleanup
rm -f r1_main r1_main_modified r1_main_modified.c
rm -rf /tmp/test_r1_dir
