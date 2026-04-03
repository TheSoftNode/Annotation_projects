#!/bin/bash

# Automated proof for R2 AOI #3: Arrow key bug

LOG_FILE="/tmp/r2_aoi3_proof.log"

echo "=== R2 AOI #3 Proof - Arrow Key Bug ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "CLAIM: Response 2 code incorrectly treats arrow keys as single characters A/B" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- Part 1: What Response 2 Code Does ---" >> "$LOG_FILE"
echo "Code from Response 2:" >> "$LOG_FILE"
echo "  read -rsn1 input" >> "$LOG_FILE"
echo "  case \$input in" >> "$LOG_FILE"
echo "      A) # Up arrow" >> "$LOG_FILE"
echo "      B) # Down arrow" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Analysis:" >> "$LOG_FILE"
echo "- read -rsn1 reads exactly ONE character" >> "$LOG_FILE"
echo "- Case checks if that character equals 'A' or 'B'" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- Part 2: What Arrow Keys Actually Send ---" >> "$LOG_FILE"
echo "Testing with printf to show hex values:" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Simulate arrow key sequence
UP_ARROW=$'\x1b[A'
echo "UP arrow key sequence:" >> "$LOG_FILE"
printf "  Full sequence: " >> "$LOG_FILE"
printf '%s' "$UP_ARROW" | od -An -tx1 | tr -d '\n' >> "$LOG_FILE"
echo " (in hex)" >> "$LOG_FILE"
printf "  Breakdown: " >> "$LOG_FILE"
printf '%s' "$UP_ARROW" | od -An -tx1c >> "$LOG_FILE"
echo "  = ESC (1b) + '[' (5b) + 'A' (41)" >> "$LOG_FILE"
echo "  = THREE characters total" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Show what read -rsn1 would get
FIRST_CHAR="${UP_ARROW:0:1}"
echo "What 'read -rsn1' captures from UP arrow:" >> "$LOG_FILE"
printf "  First character only: " >> "$LOG_FILE"
printf '%s' "$FIRST_CHAR" | od -An -tx1 | tr -d '\n' >> "$LOG_FILE"
echo " (hex 1b = ESC)" >> "$LOG_FILE"
echo "  This is NOT the letter 'A'" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- Part 3: The Bug ---" >> "$LOG_FILE"
echo "Problem:" >> "$LOG_FILE"
echo "1. Arrow UP sends: ESC + [ + A (three chars)" >> "$LOG_FILE"
echo "2. read -rsn1 captures: ESC (first char only)" >> "$LOG_FILE"
echo "3. case checks: if ESC equals 'A' → NO MATCH" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "4. Letter 'A' sends: A (one char)" >> "$LOG_FILE"
echo "5. read -rsn1 captures: A" >> "$LOG_FILE"
echo "6. case checks: if A equals 'A' → MATCH!" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- Part 4: Verification ---" >> "$LOG_FILE"
echo "CONCLUSION: R2 AOI #3 is VALID" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Evidence:" >> "$LOG_FILE"
echo "✓ Arrow keys send multi-character ANSI escape sequences" >> "$LOG_FILE"
echo "✓ Response 2 uses read -rsn1 (reads ONE character)" >> "$LOG_FILE"
echo "✓ Case statement checks for literal 'A' and 'B'" >> "$LOG_FILE"
echo "✓ Arrow key presses will NOT match (ESC ≠ A)" >> "$LOG_FILE"
echo "✓ Only typing letters A/B will trigger handlers" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "The code is broken - arrow navigation will not work." >> "$LOG_FILE"
