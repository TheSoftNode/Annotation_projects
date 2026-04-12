#!/bin/bash

# Test R1's specific claim about ptr1 variable changing
# R1 claims: "j=0: *(matrix[0]++) → *ptr1 = 1, then ptr1 → arr1[1] = 2"
# This test verifies whether ptr1 actually changes or stays at arr1[0]

echo "=========================================================================="
echo "R1 Test: Verify R1's claim about ptr1 variable modification"
echo "=========================================================================="
echo ""
echo "R1 claims (line 65-71):"
echo "  'j=0: *(matrix[0]++) → *ptr1 = 1, then ptr1 → arr1[1] = 2'"
echo "  'j=3: *(matrix[0]++) → *ptr1 = 4, then ptr1 → arr1[4]'"
echo ""
echo "This implies ptr1 itself moves during the loop."
echo "Let's test if that's true..."
echo ""

# Create test program that checks ptr1 before and after
cat > test_ptr1_unchanged.c << 'EOF'
#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};
    int* ptr1 = arr1;
    int* ptr2 = arr2;
    int* matrix[] = {ptr1, ptr2};

    printf("BEFORE loop:\n");
    printf("  ptr1 = %p (points to arr1[0])\n", (void*)ptr1);
    printf("  ptr2 = %p (points to arr2[0])\n", (void*)ptr2);
    printf("  matrix[0] = %p\n", (void*)matrix[0]);
    printf("  matrix[1] = %p\n", (void*)matrix[1]);
    printf("\n");

    // Run the original loop
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", *(matrix[i]++));
        }
        printf("\n");
    }

    printf("\nAFTER loop:\n");
    printf("  ptr1 = %p (should STILL point to arr1[0])\n", (void*)ptr1);
    printf("  ptr2 = %p (should STILL point to arr2[0])\n", (void*)ptr2);
    printf("  matrix[0] = %p (advanced to arr1[4])\n", (void*)matrix[0]);
    printf("  matrix[1] = %p (advanced to arr2[4])\n", (void*)matrix[1]);
    printf("\n");

    // Verify R1's claim
    printf("Verification:\n");

    if (ptr1 == &arr1[0]) {
        printf("  ✓ ptr1 STILL points to arr1[0] (UNCHANGED)\n");
        printf("  ✗ R1's claim is WRONG - ptr1 did NOT move to arr1[4]\n");
    } else {
        printf("  ✗ ptr1 changed (unexpected!)\n");
        printf("  ✓ R1's claim would be correct\n");
    }

    if (ptr2 == &arr2[0]) {
        printf("  ✓ ptr2 STILL points to arr2[0] (UNCHANGED)\n");
        printf("  ✗ R1's claim is WRONG - ptr2 did NOT move to arr2[4]\n");
    } else {
        printf("  ✗ ptr2 changed (unexpected!)\n");
        printf("  ✓ R1's claim would be correct\n");
    }

    printf("\n");
    printf("Conclusion:\n");
    printf("  R1 confuses 'matrix[0]' (the array element) with 'ptr1' (the variable)\n");
    printf("  matrix[0]++ increments the COPY in the array, NOT the original ptr1\n");
    printf("  This is a fundamental error in understanding C pointer semantics\n");

    return 0;
}
EOF

# Compile
echo "Compiling test program..."
gcc -Wall -Wextra -std=c11 test_ptr1_unchanged.c -o test_ptr1_unchanged 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED"
    exit 1
fi

echo "✓ Compilation successful"
echo ""

# Run
echo "Running test..."
echo "----------------------------------------------------------------------"
./test_ptr1_unchanged
echo "----------------------------------------------------------------------"
echo ""

echo "=========================================================================="
echo "R1 Factual Error CONFIRMED"
echo "=========================================================================="
echo ""
echo "R1's claim (lines 65-71): 'ptr1 → arr1[1]', 'ptr1 → arr1[4]'"
echo "Actual behavior: ptr1 remains at arr1[0] (unchanged)"
echo ""
echo "This is a SUBSTANTIAL factual error about C pointer semantics."
echo "=========================================================================="
