#!/bin/bash
# Test E: __int128 availability from R1_GPT_Factual_Task25.md

echo "============================================================"
echo "R1 Test E: __int128 Availability"
echo "============================================================"
echo

# Create the int128_test.c test file
cat > int128_test.c << 'EOF'
#include <stdio.h>

int main(void) {
    __int128 x = 1;
    x = x << 100;  // Shift left 100 bits

    printf("__int128 type is supported\n");
    printf("Successfully created and manipulated __int128 variable\n");
    printf("Value after left shift by 100: ");

    // Print the high and low 64-bit parts
    unsigned long long high = (unsigned long long)(x >> 64);
    unsigned long long low = (unsigned long long)x;
    printf("0x%016llx%016llx\n", high, low);

    return 0;
}
EOF

echo "Step 1: Attempt to compile with __int128"
echo "------------------------------------------------------------"
if gcc int128_test.c -o int128_test 2>&1; then
    echo "Compilation successful"
    echo

    echo "Step 2: Run the test"
    echo "------------------------------------------------------------"
    ./int128_test
    echo

    echo "Result: __int128 IS supported on this system"
else
    echo
    echo "Result: __int128 IS NOT supported on this system"
fi
echo

echo "Step 3: Check compiler support explicitly"
echo "------------------------------------------------------------"
gcc -dM -E - < /dev/null | grep -i int128
echo

echo "============================================================"
echo "Test E Complete"
echo "============================================================"

# Cleanup
rm -f int128_test.c int128_test
