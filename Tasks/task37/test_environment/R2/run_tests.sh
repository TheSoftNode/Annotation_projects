#!/bin/bash

# Save all outputs to R2 outputs folder
OUTPUT_DIR="../outputs/R2"
mkdir -p "$OUTPUT_DIR"

echo "=== R2 Test Suite ==="
echo ""

# Test 1: TypeScript version
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

npx tsc --noEmit > "$OUTPUT_DIR/test2_ts_ignore_import_meta.txt" 2>&1
cat "$OUTPUT_DIR/test2_ts_ignore_import_meta.txt"
echo ""

# Test 3: @ts-expect-error with import.meta (module: commonjs)
echo "Test 3: @ts-expect-error with import.meta (module: commonjs)"
cat > test.ts <<'EOF'
// @ts-expect-error
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test3_ts_expect_error_import_meta.txt" 2>&1
cat "$OUTPUT_DIR/test3_ts_expect_error_import_meta.txt"
echo ""

# Test 4: @ts-ignore with type mismatch
echo "Test 4: @ts-ignore with type mismatch"
cat > test.ts <<'EOF'
// @ts-ignore
const x: number = "hello"
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test4_ts_ignore_type_error.txt" 2>&1
cat "$OUTPUT_DIR/test4_ts_ignore_type_error.txt"
echo ""

# Test 5: @ts-ignore with syntax error
echo "Test 5: @ts-ignore with syntax error"
cat > test.ts <<'EOF'
// @ts-ignore
const x =
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test5_ts_ignore_syntax_error.txt" 2>&1
cat "$OUTPUT_DIR/test5_ts_ignore_syntax_error.txt"
echo ""

# Test 6: @ts-ignore with module resolution error
echo "Test 6: @ts-ignore with module resolution error"
cat > test.ts <<'EOF'
// @ts-ignore
import x from 'does-not-exist'
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test6_ts_ignore_module_resolution.txt" 2>&1
cat "$OUTPUT_DIR/test6_ts_ignore_module_resolution.txt"
echo ""

# Test 7: import.meta with module: es2022
echo "Test 7: import.meta with module: es2022"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2020"
  }
}
EOF

cat > test.ts <<'EOF'
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test7_import_meta_es2022.txt" 2>&1
cat "$OUTPUT_DIR/test7_import_meta_es2022.txt"
echo ""

# Test 8: import.meta with module: es2020
echo "Test 8: import.meta with module: es2020"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2020",
    "target": "es2020"
  }
}
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test8_import_meta_es2020.txt" 2>&1
cat "$OUTPUT_DIR/test8_import_meta_es2020.txt"
echo ""

# Test 9: Worker with import.meta (module: es2022)
echo "Test 9: Worker with import.meta (module: es2022)"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2022",
    "lib": ["es2020", "dom"]
  }
}
EOF

cat > test.ts <<'EOF'
const worker = new Worker(new URL('./flight.worker', import.meta.url), { type: 'module' })
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test9_worker_es2022.txt" 2>&1
cat "$OUTPUT_DIR/test9_worker_es2022.txt"
echo ""

# Test 10: Worker with import.meta (module: es2020)
echo "Test 10: Worker with import.meta (module: es2020)"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2020",
    "target": "es2020",
    "lib": ["es2020", "dom"]
  }
}
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test10_worker_es2020.txt" 2>&1
cat "$OUTPUT_DIR/test10_worker_es2020.txt"
echo ""

# Test 11: @ts-nocheck
echo "Test 11: @ts-nocheck"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es2020"
  }
}
EOF

cat > test.ts <<'EOF'
// @ts-nocheck
console.log(import.meta.url)
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test11_ts_nocheck.txt" 2>&1
cat "$OUTPUT_DIR/test11_ts_nocheck.txt"
echo ""

# Test 12: .d.ts stub with import.meta
echo "Test 12: .d.ts stub with import.meta"
mkdir -p src/lib/workers

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es2020"
  },
  "include": ["src/**/*.ts", "src/**/*.d.ts"]
}
EOF

cat > src/lib/workers/flight.worker.d.ts <<'EOF'
export {};
EOF

cat > src/test.ts <<'EOF'
const worker = new Worker(new URL('./flight.worker', import.meta.url))
EOF

npx tsc --noEmit > "$OUTPUT_DIR/test12_dts_stub.txt" 2>&1
cat "$OUTPUT_DIR/test12_dts_stub.txt"
echo ""

# Test 13: --showConfig --verbose
echo "Test 13: --showConfig --verbose"
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2022"
  }
}
EOF

npx tsc --showConfig --verbose > "$OUTPUT_DIR/test13_showconfig_verbose.txt" 2>&1
cat "$OUTPUT_DIR/test13_showconfig_verbose.txt"
echo ""

# Test 14: --showConfig | grep module
echo "Test 14: --showConfig | grep module"
npx tsc --showConfig | grep module > "$OUTPUT_DIR/test14_showconfig_grep.txt" 2>&1
cat "$OUTPUT_DIR/test14_showconfig_grep.txt"
echo ""

echo "=== All R2 tests complete ==="
