#!/bin/bash

echo "=== Testing Response 2's include path mismatch issue ==="
echo ""
echo "User's actual error is in: libs/common/src/lib/services/flight.service.ts"
echo "Response 2 recommends: \"include\": [\"src\"]"
echo ""

# Create the user's actual file structure (from the conversation history)
mkdir -p libs/common/src/lib/services

# Create the failing file in the user's actual location
cat > libs/common/src/lib/services/flight.service.ts << 'EOF'
// This is the user's actual failing file location from the conversation
export class FlightService {
  private worker = new Worker(new URL('./flight.worker', import.meta.url));
}
EOF

echo "1. Created user's actual file at: libs/common/src/lib/services/flight.service.ts"
echo ""

# Create Response 2's recommended tsconfig
cat > tsconfig_response2.json << 'EOF'
{
  "compilerOptions": {
    "target": "es2022",
    "module": "es2022",
    "lib": ["es2020", "dom"],
    "moduleResolution": "node",
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src"]
}
EOF

echo "2. Testing with Response 2's config: \"include\": [\"src\"]"
echo ""

echo "3. Running tsc with Response 2's config..."
OUTPUT=$(npx tsc --noEmit --project tsconfig_response2.json 2>&1 | grep -v "TS5107")
echo "$OUTPUT"
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ No errors reported"
    echo ""
    echo "❌ ISSUE CONFIRMED: The error disappeared because libs/common/src is NOT"
    echo "   included in the \"include\": [\"src\"] path. The file is excluded from"
    echo "   compilation, not actually fixed."
else
    echo "✗ Errors found"
    echo ""
    echo "Note: If TS1343 error appears, it means the file WAS included and the"
    echo "      config issue is different than expected."
fi

echo ""
echo "4. Now testing with correct include path..."

cat > tsconfig_correct.json << 'EOF'
{
  "compilerOptions": {
    "target": "es2022",
    "module": "commonjs",
    "lib": ["es2020", "dom"],
    "moduleResolution": "node",
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src", "libs"]
}
EOF

echo ""
echo "5. Testing with corrected config: \"include\": [\"src\", \"libs\"]"
echo ""

OUTPUT2=$(npx tsc --noEmit --project tsconfig_correct.json 2>&1 | grep -v "TS5107")
echo "$OUTPUT2"
EXIT_CODE2=$?

echo ""
if [ $EXIT_CODE2 -eq 0 ]; then
    echo "✓ No errors (file is now included and compiles successfully)"
else
    echo "✓ Errors appear (file is now included in compilation)"
fi

# Cleanup
rm -rf libs
rm tsconfig_response2.json tsconfig_correct.json
