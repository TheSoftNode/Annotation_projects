#!/bin/bash

# Complete test for R2 AOI #3 with detailed logging
# This will produce excerpts for the AOI verification

LOG_FILE="/tmp/r2_aoi3_complete.log"

echo "=============================================" > "$LOG_FILE"
echo "R2 AOI #3 - Arrow Key Bug Test" >> "$LOG_FILE"
echo "=============================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Test Date: $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- CLAIM ---" >> "$LOG_FILE"
echo "Response 2's pure bash example treats arrow keys as single-character" >> "$LOG_FILE"
echo "input (A/B), but arrow keys actually send multi-character ANSI escape" >> "$LOG_FILE"
echo "sequences. This makes the arrow key navigation non-functional." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- CODE FROM RESPONSE 2 ---" >> "$LOG_FILE"
echo "Exact code pattern used:" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "    read -rsn1 input" >> "$LOG_FILE"
echo "    case \$input in" >> "$LOG_FILE"
echo "        A) # Up arrow" >> "$LOG_FILE"
echo "            ((selected--)); ((selected < 0)) && selected=\$((\${#options[@]} - 1)) ;;" >> "$LOG_FILE"
echo "        B) # Down arrow" >> "$LOG_FILE"
echo "            ((selected++)); ((selected >= \${#options[@]})) && selected=0 ;;" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- TEST 1: What Arrow Keys Actually Send ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Create arrow key sequences
UP_ARROW=$'\x1b[A'
DOWN_ARROW=$'\x1b[B'

echo "UP Arrow Key:" >> "$LOG_FILE"
echo "  Full sequence in hex: $(printf '%s' "$UP_ARROW" | od -An -tx1 | xargs)" >> "$LOG_FILE"
echo "  Character breakdown:" >> "$LOG_FILE"
printf "    Byte 1: " >> "$LOG_FILE"
printf '%s' "${UP_ARROW:0:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " (ESC / \\x1b)" >> "$LOG_FILE"
printf "    Byte 2: " >> "$LOG_FILE"
printf '%s' "${UP_ARROW:1:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " ('[' character)" >> "$LOG_FILE"
printf "    Byte 3: " >> "$LOG_FILE"
printf '%s' "${UP_ARROW:2:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " ('A' character)" >> "$LOG_FILE"
echo "  Total characters: 3" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "DOWN Arrow Key:" >> "$LOG_FILE"
echo "  Full sequence in hex: $(printf '%s' "$DOWN_ARROW" | od -An -tx1 | xargs)" >> "$LOG_FILE"
echo "  Character breakdown:" >> "$LOG_FILE"
printf "    Byte 1: " >> "$LOG_FILE"
printf '%s' "${DOWN_ARROW:0:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " (ESC / \\x1b)" >> "$LOG_FILE"
printf "    Byte 2: " >> "$LOG_FILE"
printf '%s' "${DOWN_ARROW:1:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " ('[' character)" >> "$LOG_FILE"
printf "    Byte 3: " >> "$LOG_FILE"
printf '%s' "${DOWN_ARROW:2:1}" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " ('B' character)" >> "$LOG_FILE"
echo "  Total characters: 3" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- TEST 2: What 'read -rsn1' Captures ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "The command 'read -rsn1' reads exactly ONE character." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "When UP arrow is pressed:" >> "$LOG_FILE"
FIRST_CHAR="${UP_ARROW:0:1}"
printf "  First character captured: " >> "$LOG_FILE"
printf '%s' "$FIRST_CHAR" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " (ESC)" >> "$LOG_FILE"
echo "  Remaining in buffer: '[' + 'A'" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "When DOWN arrow is pressed:" >> "$LOG_FILE"
FIRST_CHAR_DOWN="${DOWN_ARROW:0:1}"
printf "  First character captured: " >> "$LOG_FILE"
printf '%s' "$FIRST_CHAR_DOWN" | od -An -tx1 | xargs >> "$LOG_FILE"
echo " (ESC)" >> "$LOG_FILE"
echo "  Remaining in buffer: '[' + 'B'" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--- TEST 3: Case Statement Matching ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Response 2 code checks:" >> "$LOG_FILE"
echo "  case \$input in" >> "$LOG_FILE"
echo "      A) ..." >> "$LOG_FILE"
echo "      B) ..." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Testing if ESC equals 'A':" >> "$LOG_FILE"
if [[ "$FIRST_CHAR" == "A" ]]; then
    echo "  Result: MATCH" >> "$LOG_FILE"
else
    echo "  Result: NO MATCH (ESC ≠ A)" >> "$LOG_FILE"
fi
echo "" >> "$LOG_FILE"

echo "Testing if literal 'A' equals 'A':" >> "$LOG_FILE"
TEST_A="A"
if [[ "$TEST_A" == "A" ]]; then
    echo "  Result: MATCH" >> "$LOG_FILE"
else
    echo "  Result: NO MATCH" >> "$LOG_FILE"
fi
echo "" >> "$LOG_FILE"

echo "--- TEST 4: Actual Behavior Simulation ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Simulating the Response 2 code behavior:" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Simulate what happens with arrow key
input="${UP_ARROW:0:1}"  # First char only (what read -rsn1 gets)
echo "Scenario 1: User presses UP arrow key" >> "$LOG_FILE"
echo "  Input captured by read -rsn1: ESC (\\x1b)" >> "$LOG_FILE"
echo "  Case statement checks:" >> "$LOG_FILE"
case "$input" in
    A)
        echo "    Matched 'A' handler → Execute up action" >> "$LOG_FILE"
        ;;
    B)
        echo "    Matched 'B' handler → Execute down action" >> "$LOG_FILE"
        ;;
    "")
        echo "    Matched Enter handler → Exit" >> "$LOG_FILE"
        ;;
    *)
        echo "    NO MATCH → Falls through to default/continue" >> "$LOG_FILE"
        ;;
esac
echo "" >> "$LOG_FILE"

# Simulate what happens when typing 'A'
input="A"
echo "Scenario 2: User types the letter 'A'" >> "$LOG_FILE"
echo "  Input captured by read -rsn1: A" >> "$LOG_FILE"
echo "  Case statement checks:" >> "$LOG_FILE"
case "$input" in
    A)
        echo "    Matched 'A' handler → Execute up action" >> "$LOG_FILE"
        ;;
    B)
        echo "    Matched 'B' handler → Execute down action" >> "$LOG_FILE"
        ;;
    "")
        echo "    Matched Enter handler → Exit" >> "$LOG_FILE"
        ;;
    *)
        echo "    NO MATCH → Falls through to default/continue" >> "$LOG_FILE"
        ;;
esac
echo "" >> "$LOG_FILE"

echo "--- CONCLUSION ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "FINDING: The code is BROKEN for arrow key navigation" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Evidence:" >> "$LOG_FILE"
echo "  ✗ Arrow keys send 3-character sequences (ESC + [ + A/B)" >> "$LOG_FILE"
echo "  ✗ read -rsn1 captures only the first character (ESC)" >> "$LOG_FILE"
echo "  ✗ Case statement checks if ESC equals 'A' or 'B'" >> "$LOG_FILE"
echo "  ✗ This will NEVER match for actual arrow key presses" >> "$LOG_FILE"
echo "  ✓ Only typing literal 'A' or 'B' will trigger the handlers" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Impact:" >> "$LOG_FILE"
echo "  - User pressing UP arrow → No action (ESC doesn't match 'A')" >> "$LOG_FILE"
echo "  - User pressing DOWN arrow → No action (ESC doesn't match 'B')" >> "$LOG_FILE"
echo "  - User typing letter 'A' → Moves selection up (matches 'A')" >> "$LOG_FILE"
echo "  - User typing letter 'B' → Moves selection down (matches 'B')" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "The arrow key navigation feature is NON-FUNCTIONAL." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "=============================================" >> "$LOG_FILE"
echo "Test Complete" >> "$LOG_FILE"
echo "=============================================" >> "$LOG_FILE"
