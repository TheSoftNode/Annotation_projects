#!/bin/bash
# Test F: NaN/infinity behavior from R1_GPT_Factual_Task25.md

echo "============================================================"
echo "R1 Test F: NaN and Infinity Behavior"
echo "============================================================"
echo

# Create the fp_specials.c test file
cat > fp_specials.c << 'EOF'
#include <stdio.h>
#include <math.h>

int main(void) {
    printf("Test F.1: NaN Behavior\n");
    printf("------------------------------------------------------------\n");

    double nan_val = 0.0 / 0.0;
    printf("Created NaN: 0.0 / 0.0\n");
    printf("  isnan(nan_val) = %d\n", isnan(nan_val));
    printf("  nan_val == nan_val: %d\n", nan_val == nan_val);
    printf("  nan_val != nan_val: %d\n", nan_val != nan_val);
    printf("  nan_val < 0.0: %d\n", nan_val < 0.0);
    printf("  nan_val > 0.0: %d\n", nan_val > 0.0);
    printf("  nan_val == 0.0: %d\n", nan_val == 0.0);
    printf("\n");

    printf("Test F.2: Positive Infinity\n");
    printf("------------------------------------------------------------\n");

    double pos_inf = 1.0 / 0.0;
    printf("Created +Inf: 1.0 / 0.0\n");
    printf("  isinf(pos_inf) = %d\n", isinf(pos_inf));
    printf("  pos_inf > 1e308: %d\n", pos_inf > 1e308);
    printf("  pos_inf == pos_inf: %d\n", pos_inf == pos_inf);
    printf("  pos_inf + 1.0 == pos_inf: %d\n", (pos_inf + 1.0) == pos_inf);
    printf("\n");

    printf("Test F.3: Negative Infinity\n");
    printf("------------------------------------------------------------\n");

    double neg_inf = -1.0 / 0.0;
    printf("Created -Inf: -1.0 / 0.0\n");
    printf("  isinf(neg_inf) = %d\n", isinf(neg_inf));
    printf("  neg_inf < -1e308: %d\n", neg_inf < -1e308);
    printf("  neg_inf == neg_inf: %d\n", neg_inf == neg_inf);
    printf("\n");

    printf("Test F.4: Infinity Arithmetic\n");
    printf("------------------------------------------------------------\n");

    double inf_plus_inf = pos_inf + pos_inf;
    double inf_minus_inf = pos_inf - pos_inf;
    double inf_times_zero = pos_inf * 0.0;

    printf("  +Inf + +Inf: isinf() = %d, value > 0: %d\n",
           isinf(inf_plus_inf), inf_plus_inf > 0);
    printf("  +Inf - +Inf: isnan() = %d\n", isnan(inf_minus_inf));
    printf("  +Inf * 0.0: isnan() = %d\n", isnan(inf_times_zero));
    printf("\n");

    printf("Test F.5: Comparison Propagation\n");
    printf("------------------------------------------------------------\n");

    printf("  (NaN < 5.0) = %d (should be 0)\n", nan_val < 5.0);
    printf("  (NaN > 5.0) = %d (should be 0)\n", nan_val > 5.0);
    printf("  (NaN == 5.0) = %d (should be 0)\n", nan_val == 5.0);
    printf("  All comparisons with NaN are false\n");
    printf("\n");

    return 0;
}
EOF

echo "Step 1: Compile fp_specials.c"
echo "------------------------------------------------------------"
gcc fp_specials.c -o fp_specials -lm
echo "Compilation successful"
echo

echo "Step 2: Run the test"
echo "------------------------------------------------------------"
./fp_specials
echo

echo "============================================================"
echo "Test F Complete"
echo "============================================================"

# Cleanup
rm -f fp_specials.c fp_specials
