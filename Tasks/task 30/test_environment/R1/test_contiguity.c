#include <stdio.h>
#include <stddef.h>

int main(void) {
    int arr1[] = {1, 2, 3, 4};
    int arr2[] = {5, 6, 7, 8};

    printf("&arr1[0] = %p\n", (void*)&arr1[0]);
    printf("&arr1[1] = %p\n", (void*)&arr1[1]);
    printf("&arr1[2] = %p\n", (void*)&arr1[2]);
    printf("&arr1[3] = %p\n", (void*)&arr1[3]);
    printf("&arr2[0] = %p\n", (void*)&arr2[0]);
    printf("&arr2[1] = %p\n", (void*)&arr2[1]);
    printf("byte gap from &arr1[4] to &arr2[0] = %td\n",
           (char*)&arr2[0] - (char*)&arr1[4]);
    return 0;
}
