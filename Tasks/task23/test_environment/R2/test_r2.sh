#!/bin/bash

echo "=== Testing R2 ==="

# Compile
gcc r2_main.c -o r2_main 2>&1
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi
echo "Compilation successful"
echo ""

# Test 1: Run with default hardcoded path (will fail - directory doesn't exist)
echo "Test 1: Run with hardcoded path /home/user/documents (non-existent)"
./r2_main
echo ""

# Test 2: Modify to use existing directory
echo "Test 2: Create test directory and run"
mkdir -p /tmp/test_r2_dir
sed 's|/home/user/documents/newfile.txt|/tmp/test_r2_dir/newfile.txt|g' r2_main.c > r2_main_modified.c
gcc r2_main_modified.c -o r2_main_modified 2>&1
./r2_main_modified
echo ""

# Test 3: Run again (should fail with EEXIST due to "x" mode)
echo "Test 3: Run again to test 'x' mode exclusivity"
./r2_main_modified
echo ""

# Test 4: Verify file was created
echo "Test 4: Verify file creation and content"
if [ -f "/tmp/test_r2_dir/newfile.txt" ]; then
    echo "File exists"
    cat /tmp/test_r2_dir/newfile.txt
else
    echo "File not found"
fi
echo ""

# Cleanup
rm -f r2_main r2_main_modified r2_main_modified.c
rm -rf /tmp/test_r2_dir
