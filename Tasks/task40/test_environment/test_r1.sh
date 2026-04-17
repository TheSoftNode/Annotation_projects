#!/bin/bash
# Test Response 1 - copies R1 files into the Vue project and starts dev server
cd "$(dirname "$0")/hue-test"
cp ../R1/TestGlow.vue src/TestGlow.vue
cp ../R1/App.vue src/App.vue
echo "✅ R1 files copied. Starting dev server..."
npm run dev
