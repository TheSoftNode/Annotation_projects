#include <stdio.h>
#include <stdint.h>
#include <math.h>

// From conversation history - multiply_scaled function
int64_t multiply_scaled(int64_t a, int64_t b, int64_t scale) {
    // Use 128-bit to avoid overflow
    __int128 product = (__int128)a * b;
    return (int64_t)((product + scale/2) / scale);  // with rounding
}

// From conversation history - sqrt_scaled function
int64_t sqrt_scaled(int64_t x, int64_t scale) {
    double x_double = (double)x / scale;         // to real value
    double result = sqrt(x_double);
    return (int64_t)(result * scale + 0.5);      // back to scaled int
}

// From conversation history - log_scaled function
int64_t log_scaled(int64_t x_int, int64_t scale) {
    double x = (double)x_int / scale;
    double result = log(x);  // or log10, etc.
    return (int64_t)(result * scale + 0.5);
}

int main() {
    int64_t scale = 1000000;  // micro-units

    printf("Testing conversation history code examples:\n\n");

    // Test multiply_scaled
    printf("1. Testing multiply_scaled:\n");
    int64_t a = 1234560000;  // $1,234.56
    int64_t b = 78900000;    // $78.90
    int64_t result = multiply_scaled(a, b, scale);
    printf("   $1,234.56 × $78.90 = $%.2f\n", result / (double)scale);
    printf("   Expected: $97,406.78\n\n");

    // Test sqrt_scaled
    printf("2. Testing sqrt_scaled:\n");
    int64_t x = 100000000;  // $100.00
    int64_t sqrt_result = sqrt_scaled(x, scale);
    printf("   sqrt($100.00) = $%.2f\n", sqrt_result / (double)scale);
    printf("   Expected: $10.00\n\n");

    // Test log_scaled
    printf("3. Testing log_scaled:\n");
    int64_t log_x = 7389000;  // 7.389
    int64_t log_result = log_scaled(log_x, scale);
    printf("   ln(7.389) = %.6f\n", log_result / (double)scale);
    printf("   Expected: ~2.0\n\n");

    // Test overflow scenario from conversation
    printf("4. Testing overflow scenario:\n");
    int64_t price_a = 1000000000;  // $1,000
    int64_t price_b = 1000000000;  // $1,000
    int64_t overflow_result = multiply_scaled(price_a, price_b, scale);
    printf("   $1,000 × $1,000 = $%.2f\n", overflow_result / (double)scale);
    printf("   Expected: $1,000,000\n\n");

    return 0;
}
