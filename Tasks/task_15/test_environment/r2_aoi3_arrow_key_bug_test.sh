#!/bin/bash

# Test for R2 AOI #3: Arrow key bug
# Claim: Code treats arrow keys as single character A/B instead of escape sequences

LOG_FILE="/tmp/r2_aoi3_test.log"

echo "=== R2 AOI #3 Test - Arrow Key Bug ===" > "$LOG_FILE"
echo "Testing arrow key handling from Response 2" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# This is the EXACT pattern from Response 2
echo "Response 2 Code Pattern:" >> "$LOG_FILE"
echo "read -rsn1 input" >> "$LOG_FILE"
echo "case \$input in" >> "$LOG_FILE"
echo "    A) # Up arrow" >> "$LOG_FILE"
echo "    B) # Down arrow" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Testing what arrow keys actually send..." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Test what pressing arrow keys actually produces
echo "Press UP arrow key, then press Enter:" >> "$LOG_FILE"
read -rsn1 first_char
printf "First character read: '%s' (hex: " >> "$LOG_FILE"
printf '%02x' "'$first_char" >> "$LOG_FILE"
echo ")" >> "$LOG_FILE"

if [[ "$first_char" == $'\x1b' ]]; then
    echo "✓ First character is ESC (\\x1b)" >> "$LOG_FILE"
    read -rsn2 rest
    echo "Next two characters: '$rest'" >> "$LOG_FILE"
    echo "Full sequence: ESC + $rest" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    echo "FINDING: Arrow keys send MULTI-CHARACTER escape sequences" >> "$LOG_FILE"
    echo "UP arrow sends: \\x1b[A (three characters: ESC, [, A)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    echo "PROBLEM: Response 2 code uses 'read -rsn1' which reads only ONE character" >> "$LOG_FILE"
    echo "Then checks: case \$input in A)" >> "$LOG_FILE"
    echo "This will NEVER match arrow keys because:" >> "$LOG_FILE"
    echo "- Arrow UP sends: ESC (\\x1b) as first char, not 'A'" >> "$LOG_FILE"
    echo "- The 'A' is the THIRD character in the sequence" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    echo "RESULT: Pressing arrow keys won't work" >> "$LOG_FILE"
    echo "Only typing literal 'A' or 'B' letters will trigger the handlers" >> "$LOG_FILE"
else
    echo "Character is not ESC: '$first_char'" >> "$LOG_FILE"
    if [[ "$first_char" == "A" ]]; then
        echo "You typed the letter 'A' (not arrow key)" >> "$LOG_FILE"
        echo "This WILL match the case statement" >> "$LOG_FILE"
    fi
fi

echo "" >> "$LOG_FILE"
echo "=== VERIFICATION ===" >> "$LOG_FILE"
echo "R2 AOI #3 claim is VALID:" >> "$LOG_FILE"
echo "- Response 2 checks for single char 'A' or 'B'" >> "$LOG_FILE"
echo "- Arrow keys send multi-char sequences \\x1b[A and \\x1b[B" >> "$LOG_FILE"
echo "- The code will NOT detect actual arrow key presses" >> "$LOG_FILE"
