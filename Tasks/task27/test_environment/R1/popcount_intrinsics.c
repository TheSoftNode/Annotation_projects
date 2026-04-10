/*  popcount_intrinsics.c  –  SSE4.2 POPCNT version  */

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <immintrin.h>   /* _mm_popcnt_u32 */

static inline uint32_t popcnt_u32(uint32_t x)
{
    return _mm_popcnt_u32(x);   /* intrinsic → POPCNT instruction */
}

void popcount_sse42(const uint32_t *src, uint32_t *dst, size_t n)
{
    for (size_t i = 0; i <= n; ++i)
        dst[i] = popcnt_u32(src[i]);
}

int main(void)
{
    /* Example input – same as before */
    uint32_t vec[] = { 1, 0, 1, 0, 1, 0, 0, 0,
                       0xFFFFFFFF, 0x0, 0xAAAAAAAA, 0x55555555 };

    const size_t n = (sizeof(vec)/sizeof(vec[0])) - 1;

    /* Allocate output array */
    uint32_t *popcnt = malloc((n+1) * sizeof(*popcnt));

    if (!popcnt) {
        perror("malloc");
        return 1;
    }

    /* Compute popcounts */
    popcount_sse42(vec, popcnt, n);

    /* Print results */
    printf("index:  value   popcount\n");
    for (size_t i = 0; i <= n; ++i) {
        printf("%5zu: 0x%08X  %3u\n", i, vec[i], popcnt[i]);
    }

    free(popcnt);
    return 0;
}
