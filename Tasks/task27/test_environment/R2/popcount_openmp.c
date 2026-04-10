#include <stdio.h>

#include <stdint.h>

#include <stdlib.h>

int main(void) {

    // Define 'n' (the number of elements to process)

    const size_t n = 8;

    // Initialize input vector (array)

    uint32_t vec[n] = {1, 0, 1, 0, 1, 0, 0, 0};

    // Allocate output array to store results

    uint32_t hd[n];

    // Vectorized loop using OpenMP SIMD

    // This hint tells the compiler to attempt to process multiple iterations

    // simultaneously using SIMD registers (AVX/SSE) if the hardware supports it.

    #pragma omp simd

    for (size_t i = 0; i < n; i++) {

        hd[i] = (uint32_t)__builtin_popcount(vec[i]);

    }

    // Print results from 0 to n-1

    for (size_t i = 0; i < n; i++) {

        printf("Index %zu: vec=%u, hd=%u\n", i, vec[i], hd[i]);

    }

    return 0;

}
