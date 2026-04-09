// Test 6: Verify __int128 support in the current environment
// This should compile and run successfully on 64-bit GCC/Clang.
//
// What this tests:
//   - R2 Claim 31: "On Linux/GCC/Clang (standard for HFT), __int128 is very efficient."

#include <stdio.h>
#include <stdint.h>

int main()
{
    printf("============================================================\n");
    printf("R2 Test 6: __int128 Support Verification\n");
    printf("============================================================\n\n");

#ifdef __SIZEOF_INT128__
    // Test basic multiplication
    __int128 x = (__int128)1000000000000LL * 1000000000000LL;
    // x = 10^24, which overflows int64 but fits in __int128

    // Extract high and low 64-bit halves to print
    uint64_t lo = (uint64_t)x;
    uint64_t hi = (uint64_t)(x >> 64);

    printf("__int128 is SUPPORTED\n\n");

    printf("Test: 10^12 * 10^12 = 10^24\n");
    printf("  High 64 bits: %llu\n", (unsigned long long)hi);
    printf("  Low  64 bits: %llu\n", (unsigned long long)lo);
    printf("  (int64_t max: %lld)\n\n", (long long)INT64_MAX);

    // Verify the result is correct: 10^24 = 0xD3C21BCECCEDA1000000
    // High = 54210, Low = 2003764205206896640
    printf("  Expected high: 54210\n");
    printf("  Expected low:  2003764205206896640\n");
    printf("  Match: %s\n\n", (hi == 54210 && lo == 2003764205206896640ULL) ? "YES" : "NO");

    // Test the HFT scaled multiply use case
    printf("HFT use case: $1,234.56 * $78.90 in micro-units\n");
    printf("------------------------------------------------------------\n");
    int64_t a = 1234560000; // $1,234.56 in micro-units
    int64_t b = 78900000;   // $78.90 in micro-units
    int64_t scale = 1000000;

    __int128 product = (__int128)a * b;
    int64_t result = (int64_t)((product + scale / 2) / scale);

    printf("  a = %lld (micro-units)\n", (long long)a);
    printf("  b = %lld (micro-units)\n", (long long)b);
    printf("  a * b (raw) would be: %lld * %lld\n", (long long)a, (long long)b);
    printf("  Result (scaled back): %lld\n", (long long)result);
    printf("  As dollars: $%.6f\n", (double)result / scale);
    printf("  Expected: $97,406.784000\n\n");

#else
    printf("__int128 is NOT SUPPORTED on this platform\n");
    printf("This would affect R2's claim about __int128 availability.\n\n");
#endif

    printf("============================================================\n");
    printf("What this tests:\n");
    printf("  - R2 Claim 31: '__int128' support on GCC/Clang\n");
    printf("  - Practical HFT scaled multiply with __int128\n");
    printf("============================================================\n");

    return 0;
}
