#include <stdio.h>
#include <limits.h>

int main(void) {
    unsigned length = UINT_MAX;
    printf("UINT_MAX      = %u\n", UINT_MAX);
    printf("length        = %u\n", length);
    printf("length - 1    = %u\n", length - 1);
    return 0;
}
