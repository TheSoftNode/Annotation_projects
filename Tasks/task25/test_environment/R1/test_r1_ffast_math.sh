#!/bin/bash
# Test D: -ffast-math compiler flag behavior from R1_GPT_Factual_Task25.md

echo "============================================================"
echo "R1 Test D: -ffast-math Compiler Flag Behavior"
echo "============================================================"
echo

# Create the nancheck.c test file
cat > nancheck.c << 'EOF'
#include <stdio.h>
#include <math.h>

int main(void) {
    double x = 0.0 / 0.0;  // Generate NaN

    if (isnan(x)) {
        printf("NaN detected: isnan(x) = true\n");
    } else {
        printf("NaN NOT detected: isnan(x) = false\n");
    }

    if (x != x) {
        printf("NaN self-inequality: (x != x) = true\n");
    } else {
        printf("NaN self-inequality: (x != x) = false\n");
    }

    return 0;
}
EOF

echo "Step 1: Compile WITHOUT -ffast-math"
echo "------------------------------------------------------------"
gcc nancheck.c -o nancheck_normal -lm
echo "Compilation successful"
echo

echo "Step 2: Run WITHOUT -ffast-math"
echo "------------------------------------------------------------"
./nancheck_normal
echo

echo "Step 3: Compile WITH -ffast-math"
echo "------------------------------------------------------------"
gcc -ffast-math nancheck.c -o nancheck_fast -lm
echo "Compilation successful"
echo

echo "Step 4: Run WITH -ffast-math"
echo "------------------------------------------------------------"
./nancheck_fast
echo

echo "============================================================"
echo "Test D Complete"
echo "============================================================"

# Cleanup
rm -f nancheck.c nancheck_normal nancheck_fast
