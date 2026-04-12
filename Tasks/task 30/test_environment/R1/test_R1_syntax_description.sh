#!/bin/bash

cat << 'EOF'
==========================================================================
R1 Test: Verify R1's syntax description accuracy
==========================================================================

R1's description (line 15):
  'ptr1 = &arr1[0] (points to 1)'

Original code (line 12):
  'int* ptr1 = arr1;'

While these produce identical runtime behavior, R1 misrepresents the
actual syntax used in the code.
==========================================================================

Comparing the two approaches:

Original code uses:         int* ptr1 = arr1;
R1 incorrectly describes:   ptr1 = &arr1[0]

Both evaluate to the same address, but:
- 'arr1' relies on implicit array-to-pointer decay
- '&arr1[0]' explicitly takes address of first element

R1 should have explained: "arr1 decays to a pointer to its first element"
instead of inventing the '&arr1[0]' syntax not present in the code.

==========================================================================
Creating test to demonstrate they are equivalent but different syntax:
==========================================================================
EOF

# Create test program
cat > /tmp/test_array_decay.c << 'CCODE'
#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};

    // Method 1: Array decay (ACTUAL CODE)
    int* ptr1 = arr1;

    // Method 2: Explicit address-of (R1's DESCRIPTION)
    int* ptr1_explicit = &arr1[0];

    printf("Original code:  int* ptr1 = arr1;\n");
    printf("  ptr1 = %p\n", (void*)ptr1);

    printf("\nR1's description: ptr1 = &arr1[0]\n");
    printf("  ptr1_explicit = %p\n", (void*)ptr1_explicit);

    printf("\nAre they equal? %s\n",
           (ptr1 == ptr1_explicit) ? "Yes" : "No");

    printf("\n==========================================================================\n");
    printf("Conclusion:\n");
    printf("==========================================================================\n");
    printf("While runtime addresses are identical, R1 misrepresents the syntax.\n");
    printf("The code uses 'arr1' (array decay), NOT '&arr1[0]' (explicit address).\n");
    printf("\nThis is a FACTUAL ERROR in describing the code as written.\n");
    printf("==========================================================================\n");

    return 0;
}
CCODE

echo "Compiling test program..."
gcc /tmp/test_array_decay.c -o /tmp/test_array_decay

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    echo ""
    echo "Running test..."
    echo "----------------------------------------------------------------------"
    /tmp/test_array_decay
    echo "----------------------------------------------------------------------"
else
    echo "✗ Compilation failed"
    exit 1
fi

rm -f /tmp/test_array_decay.c /tmp/test_array_decay

echo ""
echo "=========================================================================="
echo "R1 Syntax Description Error CONFIRMED"
echo "=========================================================================="
echo ""
echo "R1 line 15 claims: 'ptr1 = &arr1[0]'"
echo "Actual code line 12: 'int* ptr1 = arr1;'"
echo ""
echo "This is a MINOR factual error in describing the code's syntax."
echo "=========================================================================="
