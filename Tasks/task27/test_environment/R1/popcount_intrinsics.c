/*  popcount_intrinsics.c  –  SSE4.2 POPCNT version  */

#include <stdio.h>

#include <stdint.h>

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

/* … same main() as before, calling popcount_sse42 … */
