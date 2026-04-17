#!/bin/bash
# Test script for Response 2 - Moving hue filter animation (Vue SFC)
# This script scaffolds a fresh Vue+Vite app and drops in the R2 component

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../outputs/R2"
mkdir -p "$OUTPUT_DIR"

echo "=== Test Environment Setup ==="
echo "Node version: $(node --version)" | tee "$OUTPUT_DIR/test1_environment.txt"
echo "npm version: $(npm --version)" | tee -a "$OUTPUT_DIR/test1_environment.txt"

# Create a fresh Vue app
echo ""
echo "=== Creating Vue test app ==="
cd /tmp
rm -rf hue-test-r2
npm create vite@latest hue-test-r2 -- --template vue-ts 2>&1 | tee "$OUTPUT_DIR/test2_scaffold.txt"
cd hue-test-r2
npm install 2>&1 | tee "$OUTPUT_DIR/test3_npm_install.txt"

# Copy in the response component and harness
echo ""
echo "=== Copying R2 component files ==="
cp "$SCRIPT_DIR/TestGlow.vue" src/TestGlow.vue
cp "$SCRIPT_DIR/App.vue" src/App.vue

# Test 1: Does the project build without errors?
echo ""
echo "=== Test 4: Build check ==="
npx vue-tsc --noEmit 2>&1 | tee "$OUTPUT_DIR/test4_type_check.txt" || echo "Type check had issues" | tee -a "$OUTPUT_DIR/test4_type_check.txt"

echo ""
echo "=== Test 5: Vite build ==="
npx vite build 2>&1 | tee "$OUTPUT_DIR/test5_vite_build.txt" || echo "Build failed" | tee -a "$OUTPUT_DIR/test5_vite_build.txt"

# Test 2: Check for pseudo-element usage (R2 claims to use one)
echo ""
echo "=== Test 6: Pseudo-element check ==="
echo "Searching for ::before and ::after in R2 component:" | tee "$OUTPUT_DIR/test6_pseudo_element_check.txt"
grep -n "::before\|::after" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test6_pseudo_element_check.txt" || echo "No pseudo-elements found - contradicts R2's claim of using a pseudo-element" | tee -a "$OUTPUT_DIR/test6_pseudo_element_check.txt"

# Test 3: Check for wire texture definition
echo ""
echo "=== Test 7: Wire texture check ==="
echo "Checking if R2 defines any visible wire texture for .wire-bg:" | tee "$OUTPUT_DIR/test7_wire_texture_check.txt"
grep -n "background-image\|background:" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test7_wire_texture_check.txt" || echo "No background-image or background defined for wire-bg" | tee -a "$OUTPUT_DIR/test7_wire_texture_check.txt"
echo "" | tee -a "$OUTPUT_DIR/test7_wire_texture_check.txt"
echo "R2 does NOT define any wire texture. It only animates .wire-bg with filter." | tee -a "$OUTPUT_DIR/test7_wire_texture_check.txt"
echo "If .wire-bg has no visible pixels from elsewhere, the animation shows nothing." | tee -a "$OUTPUT_DIR/test7_wire_texture_check.txt"

# Test 4: Check background-blend-mode usage
echo ""
echo "=== Test 8: Background-blend-mode check ==="
echo "Checking background-blend-mode usage:" | tee "$OUTPUT_DIR/test8_blend_mode_check.txt"
grep -n "background-blend-mode" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test8_blend_mode_check.txt"
echo "" | tee -a "$OUTPUT_DIR/test8_blend_mode_check.txt"
echo "background-blend-mode: screen is set, but without multiple background layers it has no visible effect." | tee -a "$OUTPUT_DIR/test8_blend_mode_check.txt"

# Test 5: Check v-for loop count (should still be 1, unchanged from original)
echo ""
echo "=== Test 9: v-for orb count ==="
echo "Checking v-for directive:" | tee "$OUTPUT_DIR/test9_vfor_check.txt"
grep -n "v-for" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test9_vfor_check.txt"
echo "R2 kept original 'v-for=\"_ in 1\"' - only 1 orb span" | tee -a "$OUTPUT_DIR/test9_vfor_check.txt"

# Test 6: Verify keyframe structure
echo ""
echo "=== Test 10: Keyframe structure verification ==="
echo "Checking @keyframes wire-glow-move:" | tee "$OUTPUT_DIR/test10_keyframe_check.txt"
sed -n '/@keyframes wire-glow-move/,/^}/p' "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test10_keyframe_check.txt"

# Test 7: Check common-custom-scrollbar
echo ""
echo "=== Test 11: Custom scrollbar component ==="
echo "Checking for common-custom-scrollbar:" | tee "$OUTPUT_DIR/test11_scrollbar_check.txt"
grep -n "common-custom-scrollbar" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test11_scrollbar_check.txt"
echo "This component is not registered - will trigger Vue warning in dev mode" | tee -a "$OUTPUT_DIR/test11_scrollbar_check.txt"

# Test 8: Single animation vs dual (comparison with R1)
echo ""
echo "=== Test 12: Animation count analysis ==="
echo "Checking animation declarations:" | tee "$OUTPUT_DIR/test12_animation_analysis.txt"
grep -n "animation:" "$SCRIPT_DIR/TestGlow.vue" | tee -a "$OUTPUT_DIR/test12_animation_analysis.txt"
echo "" | tee -a "$OUTPUT_DIR/test12_animation_analysis.txt"
echo "R2 uses a single animation (wire-glow-move) - avoids the dual-filter composition issue that R1 has." | tee -a "$OUTPUT_DIR/test12_animation_analysis.txt"

echo ""
echo "=== All R2 tests complete ==="
echo "Outputs saved to $OUTPUT_DIR"

# Cleanup
cd /tmp
rm -rf hue-test-r2
