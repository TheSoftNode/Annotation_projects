#include <stdio.h>

float sum_elements(const float a[], unsigned length) {
    float result = 0.0f;

    for (unsigned i = 0; i < length; ++i) {
        result += a[i];
    }

    return result;
}

int main(void) {
    float a[] = {1.0f, 2.0f, 3.0f};
    printf("%f\n", sum_elements(a, 3));
    return 0;
}
