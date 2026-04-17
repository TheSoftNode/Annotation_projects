#!/bin/bash
# Test script for Response 1 - Moving hue filter animation (Vue SFC)
# This script scaffolds a fresh Vue+Vite app and drops in the R1 component

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../outputs/R1"
mkdir -p "$OUTPUT_DIR"

echo "=== Test Environment Setup ==="
echo "Node version: $(node --version)" | tee "$OUTPUT_DIR/test1_environment.txt"
echo "npm version: $(npm --version)" | tee -a "$OUTPUT_DIR/test1_environment.txt"

# Create a fresh Vue app
echo ""
echo "=== Creating Vue test app ==="
cd /tmp
rm -rf hue-test-r1
npm create vite@latest hue-test-r1 -- --template vue-ts 2>&1 | tee "$OUTPUT_DIR/test2_scaffold.txt"
cd hue-test-r1
npm install 2>&1 | tee "$OUTPUT_DIR/test3_npm_install.txt"

# Copy in the response component and harness
echo ""
echo "=== Copying R1 component files ==="
cp "$SCRIPT_DIR/TestGlow.vue" src/TestGlow.vue
cp "$SCRIPT_DIR/App.vue" src/App.vue

# Test 1: Does the project build without errors?
echo ""
echo "=== Test 4: Build check ==="
npx vue-tsc --noEmit 2>&1 | tee "$OUTPUT_DIR/test4_type_check.txt" || echo "Type check had issues" | tee -a "$OUTPUT_DIR/test4_type_check.txt"

echo ""
echo "=== Test 5: Vite build ==="
npx vite build 2>&1 | tee "$OUTPUT_DIR/test5_vite_build.txt" || echo "Build failed" | tee -a "$OUTPUT_DIR/test5_vite_build.txt"

# Test 2: Check for dual filter animation issue
echo ""
echo "=== Test 6: Dual filter animation analysis ==="
echo "Checking if both hueShift and glowPulse target 'filter' property:" | tee "$OUTPUT_DIR/test6_dual_filter_analysis.txt"
grep -n "filter:" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test6_dual_filter_analysis.txt"
echo "" | tee -a "$OUTPUT_DIR/test6_dual_filter_analysis.txt"
echo "Both animations target 'filter' - default animation-composition is 'replace'." | tee -a "$OUTPUT_DIR/test6_dual_filter_analysis.txt"
echo "The second animation (glowPulse) will override hueShift's filter values." | tee -a "$OUTPUT_DIR/test6_dual_filter_analysis.txt"

# Test 3: Check for pseudo-element usage
echo ""
echo "=== Test 7: Pseudo-element check ==="
echo "Searching for ::before and ::after in R1 component:" | tee "$OUTPUT_DIR/test7_pseudo_element_check.txt"
grep -n "::before\|::after" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test7_pseudo_element_check.txt" || echo "No pseudo-elements found" | tee -a "$OUTPUT_DIR/test7_pseudo_element_check.txt"

# Test 4: Check for backdrop-filter usage
echo ""
echo "=== Test 8: Backdrop-filter check ==="
echo "Searching for backdrop-filter in R1 component:" | tee "$OUTPUT_DIR/test8_backdrop_filter_check.txt"
grep -n "backdrop-filter" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test8_backdrop_filter_check.txt" || echo "No backdrop-filter found in code (only mentioned in prose)" | tee -a "$OUTPUT_DIR/test8_backdrop_filter_check.txt"

# Test 5: Check v-for loop count
echo ""
echo "=== Test 9: v-for orb count ==="
echo "Checking v-for directive:" | tee "$OUTPUT_DIR/test9_vfor_check.txt"
grep -n "v-for" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test9_vfor_check.txt"
echo "Response changed original 'v-for=\"_ in 1\"' to 'v-for=\"n in 3\"' - should render 3 orbs" | tee -a "$OUTPUT_DIR/test9_vfor_check.txt"

# Test 6: Check common-custom-scrollbar
echo ""
echo "=== Test 10: Custom scrollbar component ==="
echo "Checking for common-custom-scrollbar:" | tee "$OUTPUT_DIR/test10_scrollbar_check.txt"
grep -n "common-custom-scrollbar" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test10_scrollbar_check.txt"
echo "This component is not registered - will trigger Vue warning in dev mode" | tee -a "$OUTPUT_DIR/test10_scrollbar_check.txt"

echo ""
echo "=== All R1 tests complete ==="
echo "Outputs saved to $OUTPUT_DIR"

# Cleanup
cd /tmp
rm -rf hue-test-r1
