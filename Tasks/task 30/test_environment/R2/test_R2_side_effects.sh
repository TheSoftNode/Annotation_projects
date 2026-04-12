#!/bin/bash

# Test R2: Verify that matrix[i]++ causes side effects (modifies the stored pointers)

echo "=========================================================================="
echo "R2 Test: Side Effects Verification"
echo "=========================================================================="
echo ""
echo "Testing R2's claim: 'matrix[i]++ modifies the pointer stored in matrix[i]'"
echo ""

# Create test program that checks pointer values before and after
cat > test_R2_side_effects_check.c << 'EOF'
#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};
    int* ptr1 = arr1;
    int* ptr2 = arr2;
    int* matrix[] = {ptr1, ptr2};

    // Save original pointers
    int* original_matrix0 = matrix[0];
    int* original_matrix1 = matrix[1];

    printf("Before loop:\n");
    printf("  matrix[0] points to: %p (arr1[0])\n", (void*)matrix[0]);
    printf("  matrix[1] points to: %p (arr2[0])\n", (void*)matrix[1]);
    printf("\n");

    // Run the loop
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", *(matrix[i]++));
        }
        printf("\n");
    }

    printf("\nAfter loop:\n");
    printf("  matrix[0] points to: %p (arr1[4] - one past end)\n", (void*)matrix[0]);
    printf("  matrix[1] points to: %p (arr2[4] - one past end)\n", (void*)matrix[1]);
    printf("\n");

    // Verify side effects occurred
    if (matrix[0] != original_matrix0) {
        printf("✓ matrix[0] was modified (side effect confirmed)\n");
    } else {
        printf("✗ matrix[0] was NOT modified (unexpected!)\n");
        return 1;
    }

    if (matrix[1] != original_matrix1) {
        printf("✓ matrix[1] was modified (side effect confirmed)\n");
    } else {
        printf("✗ matrix[1] was NOT modified (unexpected!)\n");
        return 1;
    }

    // Verify they point one-past-end
    if (matrix[0] == &arr1[4]) {
        printf("✓ matrix[0] points to &arr1[4] (one past end)\n");
    } else {
        printf("✗ matrix[0] does not point to &arr1[4]\n");
        return 1;
    }

    if (matrix[1] == &arr2[4]) {
        printf("✓ matrix[1] points to &arr2[4] (one past end)\n");
    } else {
        printf("✗ matrix[1] does not point to &arr2[4]\n");
        return 1;
    }

    return 0;
}
EOF

# Compile
echo "Step 1: Compiling side effects test..."
gcc -Wall -Wextra -std=c11 test_R2_side_effects_check.c -o test_R2_side_effects_check 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED"
    exit 1
fi

echo "✓ Compilation successful"
echo ""

# Run
echo "Step 2: Running side effects test..."
echo "----------------------------------------------------------------------"
./test_R2_side_effects_check
EXIT_CODE=$?

echo "----------------------------------------------------------------------"
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo "=========================================================================="
    echo "R2 Side Effects Test: PASSED"
    echo "=========================================================================="
    echo ""
    echo "Verified R2's claims:"
    echo "  ✓ matrix[i]++ modifies the stored pointer in matrix[i]"
    echo "  ✓ After loops, pointers no longer point to array start"
    echo "  ✓ Pointers end up at one-past-end positions"
else
    echo "✗ Side effects test FAILED"
    exit 1
fi
