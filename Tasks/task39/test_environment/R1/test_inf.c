#include <stdio.h>
#include <math.h>

float sum_elements(float a[], unsigned length) {
int i;
float result = 0;

for (i = 0; i <= length-1; i++)
result += a[i];
return result;
}

int main(void) {
    float a[] = {3.4e38f, 3.4e38f};
    float s = sum_elements(a, 2);
    printf("sum=%f isinf=%d\n", s, isinf(s));
    return 0;
}
