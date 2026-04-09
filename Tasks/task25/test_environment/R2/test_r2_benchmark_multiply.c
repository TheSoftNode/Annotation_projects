#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define ITERATIONS 100000000

int main() {
    struct timespec start, end;

    printf("============================================================\n");
    printf("R2 Test C: Performance Benchmark (Multiply Operations)\n");
    printf("============================================================\n");
    printf("\n");
    printf("Running %d iterations for each test...\n\n", ITERATIONS);

    // 64-bit integer multiply
    printf("Test 1: 64-bit integer multiply\n");
    printf("------------------------------------------------------------\n");
    int64_t a = 1234567890;
    int64_t b = 9876543210;
    volatile int64_t result_int;

    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < ITERATIONS; i++) {
        result_int = a * b;
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    long long ns_int = (end.tv_sec - start.tv_sec) * 1000000000LL + (end.tv_nsec - start.tv_nsec);
    double per_op_int = (double)ns_int / ITERATIONS;
    printf("Total time: %lld ns\n", ns_int);
    printf("Per operation: %.2f ns\n", per_op_int);
    printf("Result (to prevent optimization): %lld\n\n", result_int);

    // Double multiply
    printf("Test 2: Double (64-bit float) multiply\n");
    printf("------------------------------------------------------------\n");
    double x = 1234567890.0;
    double y = 9876543210.0;
    volatile double result_double;

    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < ITERATIONS; i++) {
        result_double = x * y;
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    long long ns_double = (end.tv_sec - start.tv_sec) * 1000000000LL + (end.tv_nsec - start.tv_nsec);
    double per_op_double = (double)ns_double / ITERATIONS;
    printf("Total time: %lld ns\n", ns_double);
    printf("Per operation: %.2f ns\n", per_op_double);
    printf("Result (to prevent optimization): %f\n\n", result_double);

    // __int128 multiply (if supported)
    printf("Test 3: __int128 multiply\n");
    printf("------------------------------------------------------------\n");
#ifdef __SIZEOF_INT128__
    __int128 c = (__int128)1234567890;
    __int128 d = (__int128)9876543210;
    volatile __int128 result_int128;

    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < ITERATIONS; i++) {
        result_int128 = c * d;
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    long long ns_int128 = (end.tv_sec - start.tv_sec) * 1000000000LL + (end.tv_nsec - start.tv_nsec);
    double per_op_int128 = (double)ns_int128 / ITERATIONS;
    printf("Total time: %lld ns\n", ns_int128);
    printf("Per operation: %.2f ns\n", per_op_int128);
    printf("__int128 supported: YES\n\n");
#else
    printf("__int128 NOT supported on this platform\n\n");
#endif

    // Summary
    printf("============================================================\n");
    printf("Summary:\n");
    printf("------------------------------------------------------------\n");
    printf("64-bit int:  %.2f ns per multiply\n", per_op_int);
    printf("Double:      %.2f ns per multiply\n", per_op_double);
#ifdef __SIZEOF_INT128__
    printf("__int128:    %.2f ns per multiply\n", per_op_int128);
#endif
    printf("\nDifference: %.2f ns (%.1f%%)\n",
           per_op_double - per_op_int,
           ((per_op_double - per_op_int) / per_op_int) * 100);
    printf("\nWhat this tests:\n");
    printf("  - R2 Claim 10: '64-bit integer multiply: ~1-3 nanoseconds'\n");
    printf("  - R2 Claim 11: '128-bit integer multiply: ~10-20 nanoseconds'\n");
    printf("  - R2 Claim 12: 'Floating-point multiply: ~3-5 nanoseconds'\n");
    printf("  - R2 Claim 13: 'The difference is negligible'\n");
    printf("============================================================\n");

    return 0;
}
