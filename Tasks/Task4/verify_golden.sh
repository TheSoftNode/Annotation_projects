#!/bin/bash

echo "=== VERIFICATION CHECKLIST FOR GOLDEN ANNOTATION ==="
echo ""

# 1. Check for "responders" (should not exist)
echo "1. Checking for word 'responders'..."
if grep -i "responder" Golden_Annotation_Task4.md; then
    echo "   ❌ FOUND 'responder' - SHOULD NOT USE THIS WORD"
else
    echo "   ✅ No 'responders' found"
fi
echo ""

# 2. Check for em dashes (should not use)
echo "2. Checking for em dashes (—)..."
if grep "—" Golden_Annotation_Task4.md; then
    echo "   ❌ FOUND em dashes - REMOVE"
else
    echo "   ✅ No em dashes found"
fi
echo ""

# 3. Check all strengths start with "The response"
echo "3. Checking strengths start with 'The response'..."
grep "^The response" Golden_Annotation_Task4.md | head -15
echo "   Total found: $(grep -c '^The response' Golden_Annotation_Task4.md)"
echo ""

# 4. Check for paths (should not have absolute paths in verification)
echo "4. Checking for absolute paths..."
if grep -E "/Users/|/tmp/" Golden_Annotation_Task4.md; then
    echo "   ❌ FOUND absolute paths"
else
    echo "   ✅ No absolute paths in verification sections"
fi
echo ""

# 5. Count AOIs
echo "5. Counting AOIs..."
echo "   Response 1 AOIs: $(sed -n '/# Response 1/,/# Response 2/p' Golden_Annotation_Task4.md | grep -c '\*\*\[AOI #')"
echo "   Response 2 AOIs: $(sed -n '/# Response 2/,/# Preference/p' Golden_Annotation_Task4.md | grep -c '\*\*\[AOI #')"
echo ""

# 6. Check quality scores exist
echo "6. Checking quality scores..."
grep "Overall Quality Score:" Golden_Annotation_Task4.md
echo ""

