#include <stdio.h>
#include <stddef.h>

float sum_elements(const float a[], unsigned length)
{
    float result = 0.0f;

    /* Use size_t for the index – the same unsigned type as length. */
    for (size_t i = 0; i < length; ++i) {
        result += a[i];
    }

    return result;
}

int main(void) {
    float a[1] = {42.0f};
    printf("%f\n", sum_elements(a, 0));
    return 0;
}
