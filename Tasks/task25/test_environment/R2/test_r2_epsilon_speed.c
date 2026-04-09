#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdint.h>

#define ITERATIONS 100000000

int main()
{
    volatile int64_t int_a = 10010;
    volatile int64_t int_b = 10010;
    volatile double flt_a = 100.10;
    volatile double flt_b = 100.10;
    volatile double eps = 0.000001;
    volatile int result = 0;

    printf("============================================================\n");
    printf("R2 Test: Epsilon Comparison Speed\n");
    printf("============================================================\n\n");

    /* Benchmark: direct integer equality */
    struct timespec t1, t2;
    clock_gettime(CLOCK_MONOTONIC, &t1);
    for (int i = 0; i < ITERATIONS; i++)
    {
        result = (int_a == int_b);
    }
    clock_gettime(CLOCK_MONOTONIC, &t2);
    double int_ns = ((t2.tv_sec - t1.tv_sec) * 1e9 + (t2.tv_nsec - t1.tv_nsec)) / ITERATIONS;

    /* Benchmark: epsilon float comparison */
    clock_gettime(CLOCK_MONOTONIC, &t1);
    for (int i = 0; i < ITERATIONS; i++)
    {
        result = (fabs(flt_a - flt_b) < eps);
    }
    clock_gettime(CLOCK_MONOTONIC, &t2);
    double eps_ns = ((t2.tv_sec - t1.tv_sec) * 1e9 + (t2.tv_nsec - t1.tv_nsec)) / ITERATIONS;

    printf("Integer equality (a == b):         %.2f ns per op\n", int_ns);
    printf("Epsilon comparison (fabs < eps):   %.2f ns per op\n", eps_ns);
    printf("Overhead of epsilon comparison:    %.2f ns\n", eps_ns - int_ns);
    printf("\n");
    printf("In a 0.5ms (500,000 ns) latency budget:\n");
    printf("  Epsilon overhead is %.4f%% of the budget\n", ((eps_ns - int_ns) / 500000.0) * 100.0);
    printf("  You could do ~%d epsilon comparisons in 0.5ms\n", (int)(500000.0 / eps_ns));
    printf("\n");
    printf("============================================================\n");
    printf("CONCLUSION:\n");
    printf("  Epsilon comparison adds only ~%.1f ns overhead.\n", eps_ns - int_ns);
    printf("  Calling it 'Slow' in a 0.5ms HFT budget is misleading.\n");
    printf("============================================================\n");

    return 0;
}
