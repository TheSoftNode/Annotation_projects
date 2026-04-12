#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};

    int* ptr1 = arr1;
    int* ptr2 = arr2;

    int* matrix[] = {ptr1, ptr2};

    printf("BEFORE loop:\n");
    printf("  ptr1 = %p (offset from arr1: %ld)\n", (void*)ptr1, ptr1 - arr1);
    printf("  matrix[0] = %p (offset from arr1: %ld)\n", (void*)matrix[0], matrix[0] - arr1);

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", *(matrix[i]++));
        }
        printf("\n");
    }

    printf("\nAFTER loop:\n");
    printf("  ptr1 = %p (offset from arr1: %ld)\n", (void*)ptr1, ptr1 - arr1);
    printf("  matrix[0] = %p (offset from arr1: %ld)\n", (void*)matrix[0], matrix[0] - arr1);
    printf("\n");

    if (ptr1 - arr1 == 0) {
        printf("✓ ptr1 UNCHANGED - still points to arr1[0]\n");
    } else {
        printf("✗ ptr1 CHANGED - R1 claim would be correct\n");
    }

    if (matrix[0] - arr1 == 4) {
        printf("✓ matrix[0] advanced to arr1[4] (one-past-end)\n");
    } else {
        printf("✗ matrix[0] did NOT advance as expected\n");
    }

    return 0;
}
