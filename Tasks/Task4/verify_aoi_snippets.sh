#!/bin/bash

echo "=== VERIFYING AOI CODE SNIPPETS FROM SOURCE ==="
echo ""

# AOI #2 - yesNoPrompt
echo "Checking AOI #2 yesNoPrompt snippet..."
sed -n '218,239p' "RLHF-TASK 3.md" | head -25
echo ""

