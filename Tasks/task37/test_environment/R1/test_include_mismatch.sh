#!/bin/bash

echo "=== Testing Response 1's include mismatch issue ==="
echo ""

# Create the user's actual file structure
mkdir -p libs/common/src/lib/services

# Create the failing file in the user's actual location
cat > libs/common/src/lib/services/flight.service.ts << 'EOF'
// @ts-ignore
if (import.meta.url) {
  console.log('This triggers TS1343');
}
EOF

echo "1. Created file at: libs/common/src/lib/services/flight.service.ts"
echo ""

# Create tsconfig with Response 1's recommendation
cat > tsconfig_response1.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ES2020",
    "moduleResolution": "node",
    "strict": true
  },
  "include": ["src"]
}
EOF

echo "2. Using Response 1's recommended tsconfig with 'include': ['src']"
echo ""

echo "3. Running tsc with Response 1's config..."
npx tsc --noEmit --project tsconfig_response1.json 2>&1
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ No errors reported - but this is MISLEADING!"
    echo "  The error disappeared because libs/common/src is NOT in the 'include': ['src'] path."
    echo "  The file is excluded from compilation, not actually fixed."
else
    echo "✗ Errors found (unexpected)"
fi

echo ""
echo "4. Now testing with correct include path that covers user's actual file..."

cat > tsconfig_correct.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ES2020",
    "moduleResolution": "node",
    "strict": true
  },
  "include": ["src", "libs"]
}
EOF

npx tsc --noEmit --project tsconfig_correct.json 2>&1
EXIT_CODE2=$?

echo ""
if [ $EXIT_CODE2 -ne 0 ]; then
    echo "✓ Error correctly appears when file is actually included in compilation"
else
    echo "✗ No errors (unexpected - @ts-ignore might have suppressed it)"
fi

# Cleanup
rm -rf libs
rm tsconfig_response1.json tsconfig_correct.json
