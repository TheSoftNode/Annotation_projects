#!/bin/bash

echo "=== R1 COMPREHENSIVE FACTUAL TESTS ==="
echo ""

# Test 1: Compile the exact code unchanged
echo "TEST 1: Compile exact code from response (expect errno/EEXIST errors)"
gcc r1_main.c -o r1_main 2>&1
COMPILE_STATUS=$?
if [ $COMPILE_STATUS -ne 0 ]; then
    echo "RESULT: Compilation failed (as expected - missing errno.h)"
else
    echo "RESULT: Compilation succeeded (unexpected)"
fi
echo ""

# Test 2: Verify mkdir doesn't create parent directories
echo "TEST 2: Verify plain mkdir doesn't create missing parent directories"
rm -rf /tmp/r1-dir-check
mkdir /tmp/r1-dir-check/one/two 2>&1
if [ $? -ne 0 ]; then
    echo "RESULT: mkdir failed with missing parents (correct POSIX behavior)"
else
    echo "RESULT: mkdir succeeded (unexpected)"
fi
rm -rf /tmp/r1-dir-check
echo ""

# Test 3: Check fopen "w" mode documentation claim
echo "TEST 3: Check man page for fopen mode 'w' behavior"
man 3 fopen 2>/dev/null | grep -A 2 "w or wb" | head -5
echo ""

# Test 4: Check mkdir EEXIST documentation
echo "TEST 4: Check man page for mkdir EEXIST behavior"
man 2 mkdir 2>/dev/null | grep -A 2 "EEXIST" | head -5
echo ""

# Test 5: Fix the code and test (add errno.h)
echo "TEST 5: Fix missing errno.h and test with /tmp directory"
cat > r1_fixed.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h>

int main() {
    const char *directory = "/tmp/test_r1_fixed";
    const char *filename = "newfile.txt";
    char fullPath[1024];

    snprintf(fullPath, sizeof(fullPath), "%s/%s", directory, filename);

    if (mkdir(directory, 0777) == -1) {
        if (errno != EEXIST) {
            perror("Failed to create directory");
            return 1;
        }
    }

    FILE *file = fopen(fullPath, "w");
    if (file == NULL) {
        perror("Failed to create file");
        return 1;
    }

    fprintf(file, "This is the content of the new file.");
    fclose(file);
    printf("File created successfully at: %s\n", fullPath);
    return 0;
}
EOF

gcc r1_fixed.c -o r1_fixed 2>&1
if [ $? -eq 0 ]; then
    echo "Fixed code compiled successfully"
    ./r1_fixed
    if [ -f "/tmp/test_r1_fixed/newfile.txt" ]; then
        echo "File created successfully"
        cat /tmp/test_r1_fixed/newfile.txt
    fi
else
    echo "Fixed code compilation failed"
fi
echo ""

# Cleanup
rm -f r1_fixed r1_fixed.c
rm -rf /tmp/test_r1_fixed

echo "=== R1 TESTS COMPLETE ==="
