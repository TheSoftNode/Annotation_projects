#include <stdio.h>

int main() {

    int arr1[] = {1, 2, 3, 4};

    int arr2[] = {5, 6, 7, 8};

    int* ptr1 = arr1;

    int* ptr2 = arr2;

    int* matrix[] = {ptr1, ptr2};

    // Alternative 2: Using temporary pointer (no side effects on matrix)
    for (int i = 0; i < 2; i++) {

        int* temp = matrix[i];  // copy the row pointer

        for (int j = 0; j < 4; j++) {

            printf("%d ", *temp++);

        }

        printf("\n");

    }

    return 0;
}
