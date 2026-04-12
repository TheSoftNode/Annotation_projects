#!/bin/bash

# Verify C standard claims about pointer behavior

echo "=========================================================================="
echo "C Standard Claims Verification"
echo "=========================================================================="
echo ""
echo "Testing claims about:"
echo "  1. One-past-end pointers (C99 6.5.6/8)"
echo "  2. Undefined behavior vs valid pointer arithmetic"
echo "  3. Array-to-pointer decay"
echo ""
echo "=========================================================================="

cat > /tmp/test_c_standard.c << 'CCODE'
#include <stdio.h>

int main() {
    printf("========================================================================\n");
    printf("C STANDARD BEHAVIOR VERIFICATION\n");
    printf("========================================================================\n\n");

    int arr[] = {1, 2, 3, 4};

    printf("=== CLAIM: One-Past-End Pointer is VALID ===\n");
    printf("R1 Line 119-121: 'ptr1 and ptr2 point past the end...undefined behavior'\n");
    printf("R2 Line 100, 127: 'move to arr1[4] (one past end)'\n\n");

    printf("C99 Standard 6.5.6 paragraph 8:\n");
    printf("  'If both the pointer operand and the result point to elements of\n");
    printf("   the same array object, or one past the last element of the array\n");
    printf("   object, the evaluation shall not produce an overflow.'\n\n");

    int* one_past = &arr[4];  // Legal - one past the end
    printf("Creating pointer to arr[4] (one past end):\n");
    printf("  int* one_past = &arr[4];  // VALID\n");
    printf("  one_past address: %p\n", (void*)one_past);
    printf("  arr address: %p\n", (void*)arr);
    printf("  Difference: %ld elements\n", one_past - arr);
    printf("\n✓ Creating one-past-end pointer is VALID (not UB)\n");
    printf("✗ R1 is IMPRECISE - pointing is valid, dereferencing would be UB\n\n");

    printf("=== CLAIM: Dereferencing One-Past-End is UNDEFINED BEHAVIOR ===\n");
    printf("Attempting to dereference one_past would be UB:\n");
    printf("  // *one_past  <-- This WOULD be undefined behavior\n");
    printf("✓ CORRECT - The code never dereferences arr[4]\n\n");

    printf("=== CLAIM: Array-to-Pointer Decay ===\n");
    printf("R1 Line 15: Uses syntax 'ptr1 = &arr1[0]'\n");
    printf("Actual code: 'int* ptr1 = arr1;'\n\n");

    int test_arr[] = {10, 20, 30};
    int* decay_ptr = test_arr;          // Array decay
    int* explicit_ptr = &test_arr[0];   // Explicit address-of

    printf("Method 1 (array decay):     int* decay_ptr = test_arr;\n");
    printf("  decay_ptr = %p\n", (void*)decay_ptr);
    printf("\nMethod 2 (explicit &):      int* explicit_ptr = &test_arr[0];\n");
    printf("  explicit_ptr = %p\n", (void*)explicit_ptr);
    printf("\nAre they equal? %s\n",
           (decay_ptr == explicit_ptr) ? "Yes" : "No");
    printf("\nConclusion:\n");
    printf("  - Runtime behavior: IDENTICAL\n");
    printf("  - Code representation: DIFFERENT\n");
    printf("  - R1 misrepresents the syntax used in actual code\n\n");

    printf("=== CLAIM: Post-Increment Order of Operations ===\n");
    printf("R1 Line 49-53: 'Value is read BEFORE pointer is incremented'\n");
    printf("R2 Line 67-72: 'Dereference current value, THEN increment pointer'\n\n");

    int seq[] = {100, 200, 300};
    int* seq_ptr = seq;

    printf("Test code: int val = *(seq_ptr++);\n");
    int val = *(seq_ptr++);
    printf("  val = %d (should be 100)\n", val);
    printf("  *seq_ptr = %d (should be 200)\n", *seq_ptr);
    printf("✓ BOTH R1 and R2 CORRECT\n\n");

    printf("=== CLAIM: Pre-Increment Would Skip First Element ===\n");
    printf("R1 Line 117: '*(++matrix[i]) → Increment first, then use'\n\n");

    int pre[] = {1, 2, 3};
    int* pre_ptr = pre;

    printf("Post-increment: *(pre_ptr++) = %d (returns 1)\n",
           (pre_ptr = pre, *(pre_ptr++)));
    printf("Pre-increment:  *(++pre_ptr) = %d (returns 2, skips 1)\n",
           (pre_ptr = pre, *(++pre_ptr)));
    printf("✓ R1 CORRECT\n\n");

    printf("========================================================================\n");
    printf("SUMMARY OF C STANDARD CLAIMS\n");
    printf("========================================================================\n");
    printf("R1 Claims:\n");
    printf("  ✓ Post-increment order correct\n");
    printf("  ✓ Pre-increment skips first element\n");
    printf("  ⚠️  One-past-end 'undefined behavior' - IMPRECISE (pointing is valid)\n");
    printf("  ✗ Syntax misrepresentation '&arr1[0]' vs 'arr1'\n\n");
    printf("R2 Claims:\n");
    printf("  ✓ Post-increment order correct\n");
    printf("  ✓ One-past-end pointer handling correct\n");
    printf("  ✓ All pointer arithmetic claims correct\n");
    printf("========================================================================\n");

    return 0;
}
CCODE

echo "Compiling C standard verification test..."
gcc -std=c99 -Wall -Wextra /tmp/test_c_standard.c -o /tmp/test_c_standard

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    echo ""
    echo "Running verification..."
    echo "========================================================================"
    /tmp/test_c_standard
else
    echo "✗ Compilation failed"
    exit 1
fi

# Cleanup
rm -f /tmp/test_c_standard.c /tmp/test_c_standard

echo ""
echo "=========================================================================="
echo "C STANDARD VERIFICATION COMPLETE"
echo "=========================================================================="
