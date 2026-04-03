#!/bin/bash

# Test script for AOI #2: Whiptail example with no processing logic
# Claim: CHOICE variable is captured but never used

LOG_FILE="/tmp/whiptail_test.log"
echo "=== Whiptail Example Test - $(date) ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Instructions: Test each option (1, 2, 3, 4) to see what happens" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

iteration=0

while true; do
    ((iteration++))
    echo "[Selection $iteration] Displaying whiptail menu..." >> "$LOG_FILE"

    # THIS IS THE EXACT CODE FROM RESPONSE 1 - verbatim
    CHOICE=$(whiptail --title "Menu" --menu "Choose:" 15 50 4 \
        "1" "Check Disk Space" \
        "2" "Check Memory Usage" \
        "3" "Show Processes" \
        "4" "Exit" 3>&1 1>&2 2>&3)

    exit_status=$?

    echo "[Selection $iteration] User selected: '$CHOICE' (exit status: $exit_status)" >> "$LOG_FILE"

    # THE ORIGINAL CODE STOPS HERE - NO PROCESSING
    # Response 1 has NO case statement or any code after this line

    echo "[Selection $iteration] ⚠️  CHOICE variable captured but NEVER USED in Response 1" >> "$LOG_FILE"
    echo "[Selection $iteration] ⚠️  No case statement to process the selection" >> "$LOG_FILE"
    echo "[Selection $iteration] ⚠️  No action taken based on user's choice '$CHOICE'" >> "$LOG_FILE"

    # For testing purposes, we'll add logic to continue the loop
    # But this demonstrates the original code is incomplete
    if [ "$CHOICE" = "4" ] || [ $exit_status -ne 0 ]; then
        echo "" >> "$LOG_FILE"
        echo "=== TEST COMPLETE ===" >> "$LOG_FILE"
        echo "Total selections made: $iteration" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        echo "CONCLUSION: Response 1's whiptail example is INCOMPLETE" >> "$LOG_FILE"
        echo "- Captures user selection in \$CHOICE variable" >> "$LOG_FILE"
        echo "- But provides NO code to process the selection" >> "$LOG_FILE"
        echo "- Users cannot run this code successfully without adding their own case statement" >> "$LOG_FILE"
        break
    fi

    echo "[Selection $iteration] Script would end here in Response 1's example (incomplete)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
done
