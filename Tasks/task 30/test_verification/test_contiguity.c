#include <stdio.h>

int main() {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};

    printf("arr1 address: %p\n", (void*)arr1);
    printf("arr2 address: %p\n", (void*)arr2);
    printf("arr1 ends at: %p\n", (void*)(&arr1[4]));

    long distance = (char*)arr2 - (char*)(&arr1[4]);
    printf("\nDistance between arr1[4] and arr2: %ld bytes\n", distance);

    if (distance == 0) {
        printf("Arrays ARE contiguous (adjacent in memory)\n");
        printf("R1's claim 'not contiguous' would be WRONG for this execution\n");
    } else {
        printf("Arrays are NOT contiguous (separated by %ld bytes)\n", distance);
        printf("R1's claim matches this execution, but C doesn't GUARANTEE this\n");
    }

    printf("\nConclusion: R1 claims arr1 and arr2 are 'not contiguous',\n");
    printf("but C standard does NOT guarantee separate arrays are non-contiguous.\n");
    printf("They could be adjacent - R1 makes an unprovable claim.\n");

    return 0;
}
