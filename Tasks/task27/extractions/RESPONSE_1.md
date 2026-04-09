Below is a **self‑contained, portable example** that

* stores the input values in `uint32_t vec[]`,
* computes the population‑count (Hamming weight) for **every element** from index 0 through `n`,
* puts the results into `uint32_t popcnt[]`,
* and does the work with **explicit SIMD vectorisation** so the compiler can emit packed‑popcnt instructions (or fall back to a scalar loop if the target lacks them).

The code works with GCC, Clang and any compiler that understands the GNU vector‑extension syntax.
If your CPU supports POPCNT (SSE4.2 on x86‑64) the intrinsics version will be even faster; a fallback pure‑C version is also shown.

---

## **1\. Full program (C11)**

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

### **What the program does**

| Step | Description |
| ----- | ----- |
| **Typedef** `v4ui` | A GCC/Clang vector type that holds four `uint32_t` in a 128‑bit register (`__attribute__((vector_size(16)))`). |
| **`vec_popcnt`** | Implements the classic SWAR (SIMD‑Within‑A‑Register) popcount using only bitwise ops, shifts and adds. Because the operations are performed on the vector type, the compiler can emit them as *packed* instructions (e.g. `pand`, `psrlw`, `paddw` on x86, or the equivalent NEON instructions on ARM). If the target provides a hardware POPCNT, GCC/Clang will often recognise the pattern and replace the whole sequence with a single `popcnt` per lane. |
| **Main loop** | Loads four elements at a time, applies `vec_popcnt`, stores the four results. The final "tail" loop handles any leftover elements (0‑3) with a scalar `__builtin_popcount`. |
| **Build flags** | `-O3 -march=native` tells the compiler to tune for the host CPU and to enable auto‑vectorisation; the explicit SIMD types guarantee vectorisation even if the optimizer would otherwise skip it. |

---

## **2\. Alternative: Intrinsics‑based version (x86‑64, SSE4.2)**

If you know you are compiling for an x86‑64 CPU that supports POPCNT (SSE4.2), you can use the Intel intrinsics directly. This often yields the *fastest* code because the compiler emits a single `popcnt` instruction per lane.

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

Compile with:

gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42

On CPUs lacking POPCNT the `-msse4.2` flag will cause a compile‑time error; you can guard it with `#ifdef __SSE4_2__` and fall back to the SWAR version shown earlier.

---

## **3\. How to verify vectorisation**

After building, ask the compiler to show you what it did:

# GCC/Clang

gcc -O3 -march=native -fverbose-asm -S popcount_vector.c -o - | grep -E "popcnt|padd|psrl|pand|movdqa"

You should see instructions like:

* `vpand`, `vpsrlw`, `vpaddw` (AVX2) **or**
* `popcnt %eax, %eax` (SSE4.2 POPCNT) inside the loop body.

If you only see scalar `movzbl`/`andl`/`addl` loops, either:

* the target does not support the required ISA (re‑compile with `-march=native` or explicitly `-msse4.2`/`-mavx2`), or
* the optimisation level is too low (use `-O2` or higher).

---

## **4\. Adapting to your own data**

* **Change the source array** – just fill `vec[]` with your own values or read them from a file.
* **Adjust `n`** – set `n` to the last index you want to process (`n = length‑1`).
* **Output** – `popcnt[i]` now holds the Hamming weight of `vec[i]` for every `i` in `[0, n]`.

That's it\! You now have a **vectorised, portable popcount** that works for any range `0 … n` and automatically falls back to a fast scalar path when needed. Happy coding\!
