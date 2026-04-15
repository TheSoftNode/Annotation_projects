#!/bin/bash

# Save all outputs to R1 outputs folder
OUTPUT_DIR="../outputs/R1"
mkdir -p "$OUTPUT_DIR"

echo "=== R1 Test Suite ==="
echo ""

# Test 1: Check TypeScript version
echo "Test 1: TypeScript version"
npx tsc -v > "$OUTPUT_DIR/test1_tsc_version.txt" 2>&1
cat "$OUTPUT_DIR/test1_tsc_version.txt"
echo ""

# Test 2: @ts-ignore with import.meta (module: commonjs)
echo "Test 2: @ts-ignore with import.meta (module: commonjs)"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es2020"
  }
}
EOF

cat > test.ts <<'EOF'
// @ts-ignore
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test2_ts_ignore_commonjs.txt" 2>&1
cat "$OUTPUT_DIR/test2_ts_ignore_commonjs.txt"
echo ""

# Test 3: @ts-expect-error with import.meta (module: commonjs)
echo "Test 3: @ts-expect-error with import.meta (module: commonjs)"
cat > test.ts <<'EOF'
// @ts-expect-error
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test3_ts_expect_error_commonjs.txt" 2>&1
cat "$OUTPUT_DIR/test3_ts_expect_error_commonjs.txt"
echo ""

# Test 4: import.meta without suppression (module: commonjs)
echo "Test 4: import.meta without suppression (module: commonjs)"
cat > test.ts <<'EOF'
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test4_no_suppression_commonjs.txt" 2>&1
cat "$OUTPUT_DIR/test4_no_suppression_commonjs.txt"
echo ""

# Test 5: import.meta with module: es2020
echo "Test 5: import.meta with module: es2020"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2020",
    "target": "es2020"
  }
}
EOF

cat > test.ts <<'EOF'
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test5_import_meta_es2020.txt" 2>&1
cat "$OUTPUT_DIR/test5_import_meta_es2020.txt"
echo ""

# Test 6: import.meta with module: es2022
echo "Test 6: import.meta with module: es2022"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2020"
  }
}
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test6_import_meta_es2022.txt" 2>&1
cat "$OUTPUT_DIR/test6_import_meta_es2022.txt"
echo ""

# Test 7: import.meta with module: node16
echo "Test 7: import.meta with module: node16"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "node16",
    "target": "es2020"
  }
}
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test7_import_meta_node16.txt" 2>&1
cat "$OUTPUT_DIR/test7_import_meta_node16.txt"
echo ""

# Test 8: import.meta with module: node18
echo "Test 8: import.meta with module: node18"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "node18",
    "target": "es2020"
  }
}
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test8_import_meta_node18.txt" 2>&1
cat "$OUTPUT_DIR/test8_import_meta_node18.txt"
echo ""

# Test 9: --showConfig --verbose
echo "Test 9: --showConfig --verbose"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2022"
  }
}
EOF

npx tsc --showConfig --verbose > "$OUTPUT_DIR/test9_showconfig_verbose.txt" 2>&1
cat "$OUTPUT_DIR/test9_showconfig_verbose.txt"
echo ""

# Test 10: --showConfig (without --verbose)
echo "Test 10: --showConfig (without --verbose)"
npx tsc --showConfig > "$OUTPUT_DIR/test10_showconfig.txt" 2>&1
cat "$OUTPUT_DIR/test10_showconfig.txt"
echo ""

# Test 11: extends inheritance
echo "Test 11: extends inheritance"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022"
  }
}
EOF

mkdir -p child
cat > child/tsconfig.json <<'EOF'
{
  "extends": "../tsconfig.json"
}
EOF

cd child
npx tsc --showConfig > "../../outputs/R1/test11_extends_inheritance.txt" 2>&1
cat "../../outputs/R1/test11_extends_inheritance.txt"
cd ..
echo ""

echo "=== All R1 tests complete ==="
