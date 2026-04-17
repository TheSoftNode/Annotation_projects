#!/bin/bash
# Test Response 2 - copies R2 files into the Vue project and starts dev server
cd "$(dirname "$0")/hue-test"
cp ../R2/TestGlow.vue src/TestGlow.vue
cp ../R2/App.vue src/App.vue
echo "✅ R2 files copied. Starting dev server..."
npm run dev
