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
    float a[] = {1.0f, NAN, 3.0f};
    float s = sum_elements(a, 3);
    printf("sum=%f isnan=%d\n", s, isnan(s));
    return 0;
}
