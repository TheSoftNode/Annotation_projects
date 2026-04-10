/*  popcount_vector.c

 *

 *  Compute popcount(vec[0]) … popcount(vec[n]) using SIMD vectorisation.

 *  Build with:

 *      gcc -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector

 *  (or clang with the same flags)

 */

#include <stdio.h>

#include <stdint.h>

#include <stddef.h>   /* for size_t */

/* ------------------------------------------------------------------ */

/*  Helper: scalar popcount – used for the tail that does not fill a   */

/*  whole SIMD lane.  __builtin_popcount is a GCC/Clang intrinsic that */

/*  maps to the POPCNT instruction when the target supports it.       */

/* ------------------------------------------------------------------ */

static inline uint32_t scalar_popcnt(uint32_t x)

{

    return (uint32_t)__builtin_popcount(x);

}

/* ------------------------------------------------------------------ */

/*  SIMD helpers – we work with 128‑bit lanes that hold four uint32_t. */

/* ------------------------------------------------------------------ */

typedef uint32_t v4ui __attribute__((vector_size(16)));   /* 4 × 32‑bit */

/* POPCNT for a whole vector.  GCC/Clang provide __builtin_popcount

 * that works on an unsigned int; we apply it lane‑wise with a

 * ternary‑style expression that the compiler can turn into a

 * vectorized POPCNT if the target has the instruction.

 *

 * If the target lacks POPCNT the code below still compiles – it will

 * be turned into a sequence of shifts, adds and masks (the classic

 * SWAR popcount) which is still SIMD‑friendly.

 */

static inline v4ui vec_popcnt(v4ui v)

{

    /* SWAR popcount (parallel bit‑count) – works for any width.

     * The sequence is exactly the same as the well‑known

     * 32‑bit parallel popcount, only applied to each lane

     * simultaneously thanks to the vector type.

     */

    v4ui x = v;

    x = x - ((x >> 1) & 0x55555555u);

    x = (x & 0x33333333u) + ((x >> 2) & 0x33333333u);

    x = (x + (x >> 4)) & 0x0F0F0F0Fu;

    x = x + (x >> 8);

    x = x + (x >> 16);

    return x & 0x0000003Fu;   /* each lane now holds the count (0‑32) */

}

/* ------------------------------------------------------------------ */

/*  Main routine – vectorised loop over [0, n]                         */

/* ------------------------------------------------------------------ */

void popcount_vector(const uint32_t *src, uint32_t *dst, size_t n)

{

    size_t i = 0;

    size_t vec_len = n + 1;                 /* number of elements to process */

    /* Process full SIMD chunks (4 elements at a time) */

    for (; i + 3 < vec_len; i += 4) {

        v4ui chunk = ((v4ui*)src)[i/4];     /* load 4 × uint32_t */

        v4ui res   = vec_popcnt(chunk);    /* SIMD popcount */

        ((v4ui*)dst)[i/4] = res;           /* store 4 results */

    }

    /* Handle the remaining 0‑3 elements with the scalar fallback */

    for (; i < vec_len; ++i) {

        dst[i] = scalar_popcnt(src[i]);

    }

}

/* ------------------------------------------------------------------ */

/*  Demo / test harness                                                */

/* ------------------------------------------------------------------ */

int main(void)

{

    /* Example input – feel free to change the size or the values */

    uint32_t vec[] = { 1, 0, 1, 0, 1, 0, 0, 0,

                       0xFFFFFFFF, 0x0, 0xAAAAAAAA, 0x55555555 };

    const size_t n = (sizeof(vec)/sizeof(vec[0])) - 1;   /* last valid index */

    /* Allocate output array */

    uint32_t *popcnt = malloc((n+1) * sizeof(*popcnt));

    if (!popcnt) {

        perror("malloc");

        return 1;

    }

    /* Compute popcounts */

    popcount_vector(vec, popcnt, n);

    /* Print results */

    printf("index:  value   popcount\n");

    for (size_t i = 0; i <= n; ++i) {

        printf("%5zu: 0x%08X  %3u\n", i, vec[i], popcnt[i]);

    }

    free(popcnt);

    return 0;

}
