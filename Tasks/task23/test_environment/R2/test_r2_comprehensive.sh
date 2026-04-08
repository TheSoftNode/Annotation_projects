#!/bin/bash

echo "=== R2 COMPREHENSIVE FACTUAL TESTS ==="
echo ""

# Test 1: Compile the exact code unchanged
echo "TEST 1: Compile exact code from response"
gcc r2_main.c -o r2_main 2>&1
COMPILE_STATUS=$?
if [ $COMPILE_STATUS -eq 0 ]; then
    echo "RESULT: Compilation succeeded (code is compile-valid)"
else
    echo "RESULT: Compilation failed (unexpected)"
    exit 1
fi
echo ""

# Test 2: Run with hardcoded path (expect ENOENT)
echo "TEST 2: Run with hardcoded /home/user/documents path (expect failure)"
./r2_main 2>&1
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
echo ""

# Test 3: Verify the hardcoded path doesn't exist
echo "TEST 3: Check if hardcoded path exists"
ls -ld /home/user 2>&1
ls -ld /home/user/documents 2>&1
echo ""

# Test 4: Test with existing directory
echo "TEST 4: Create directory and test file creation"
mkdir -p /tmp/test_r2_dir
cat > r2_modified.c << 'EOF'
#include <stdio.h>
#include <errno.h>
#include <string.h>

int main() {
    const char *filepath = "/tmp/test_r2_dir/newfile.txt";

    FILE *file = fopen(filepath, "wx");
    if (file == NULL) {
        perror("Error opening file");
        if (errno == EEXIST) {
            fprintf(stderr, "File already exists: %s\n", filepath);
        } else if (errno == ENOENT) {
            fprintf(stderr, "Directory does not exist: %s\n", filepath);
        }
        return 1;
    }

    fprintf(file, "Hello, this is a new file!\n");
    fclose(file);
    printf("File created successfully at: %s\n", filepath);
    return 0;
}
EOF

gcc r2_modified.c -o r2_modified 2>&1
./r2_modified
echo ""

# Test 5: Test "wx" exclusive mode (run again - should fail with EEXIST)
echo "TEST 5: Run again to test 'wx' exclusive creation (expect EEXIST)"
./r2_modified
echo ""

# Test 6: Verify file content
echo "TEST 6: Verify file was created and contains correct content"
if [ -f "/tmp/test_r2_dir/newfile.txt" ]; then
    echo "File exists"
    cat /tmp/test_r2_dir/newfile.txt
else
    echo "File not found"
fi
echo ""

# Test 7: Test "w" mode (overwrite)
echo "TEST 7: Test 'w' mode for overwriting"
cat > r2_overwrite.c << 'EOF'
#include <stdio.h>

int main() {
    const char *filepath = "/tmp/test_r2_dir/overwrite_test.txt";

    // First write
    FILE *file = fopen(filepath, "w");
    if (file) {
        fprintf(file, "First write\n");
        fclose(file);
        printf("First write successful\n");
    }

    // Second write (should overwrite)
    file = fopen(filepath, "w");
    if (file) {
        fprintf(file, "Second write (overwritten)\n");
        fclose(file);
        printf("Second write successful\n");
    }

    return 0;
}
EOF

gcc r2_overwrite.c -o r2_overwrite 2>&1
./r2_overwrite
cat /tmp/test_r2_dir/overwrite_test.txt
echo ""

# Test 8: Check fopen documentation
echo "TEST 8: Check man page for fopen 'w' and 'x' modes"
man 3 fopen 2>/dev/null | grep -A 3 "exclusive" | head -10
echo ""

# Cleanup
rm -f r2_main r2_modified r2_modified.c r2_overwrite r2_overwrite.c
rm -rf /tmp/test_r2_dir

echo "=== R2 TESTS COMPLETE ==="
