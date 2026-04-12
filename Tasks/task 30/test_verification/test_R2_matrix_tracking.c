#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};

    int* ptr1 = arr1;
    int* ptr2 = arr2;

    int* matrix[] = {ptr1, ptr2};

    printf("=== R2 Verification: matrix[i] mutation tracking ===\n\n");

    printf("BEFORE any loops:\n");
    printf("  matrix[0] - arr1 = %ld (should be 0)\n", matrix[0] - arr1);
    printf("  matrix[1] - arr2 = %ld (should be 0)\n", matrix[1] - arr2);
    printf("  *matrix[0] = %d\n", *matrix[0]);
    printf("  *matrix[1] = %d\n\n", *matrix[1]);

    // First iteration tracking
    printf("First row (i=0):\n");
    for (int j = 0; j < 4; j++) {
        printf("  j=%d: matrix[0]-arr1=%ld, *matrix[0]=%d, printing: ",
               j, matrix[0] - arr1, *matrix[0]);
        printf("%d\n", *(matrix[0]++));
    }
    printf("  After first row: matrix[0] - arr1 = %ld (one-past-end)\n", matrix[0] - arr1);
    printf("  matrix[1] still: matrix[1] - arr2 = %ld (untouched)\n\n", matrix[1] - arr2);

    // Second iteration tracking
    printf("Second row (i=1):\n");
    for (int j = 0; j < 4; j++) {
        printf("  j=%d: matrix[1]-arr2=%ld, *matrix[1]=%d, printing: ",
               j, matrix[1] - arr2, *matrix[1]);
        printf("%d\n", *(matrix[1]++));
    }
    printf("  After second row: matrix[1] - arr2 = %ld (one-past-end)\n\n", matrix[1] - arr2);

    printf("=== R2 Claims Verified ===\n");
    printf("✓ matrix[0] advanced from 0 to 4 during first row\n");
    printf("✓ matrix[1] remained 0 during first row (untouched)\n");
    printf("✓ matrix[1] advanced from 0 to 4 during second row\n");
    printf("✓ One-past-end pointers created (offset 4)\n");

    return 0;
}
