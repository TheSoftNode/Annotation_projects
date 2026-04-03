#!/bin/bash

# Test script for AOI #2: Whiptail example with no processing logic
# Claim: CHOICE variable is captured but never used

LOG_FILE="/tmp/whiptail_test.log"
echo "=== Whiptail Example Test - $(date) ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Running whiptail menu..." >> "$LOG_FILE"

CHOICE=$(whiptail --title "Menu" --menu "Choose:" 15 50 4 \
    "1" "Check Disk Space" \
    "2" "Check Memory Usage" \
    "3" "Show Processes" \
    "4" "Exit" 3>&1 1>&2 2>&3)

exit_status=$?

echo "User selected: '$CHOICE' (exit status: $exit_status)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Check if CHOICE is used anywhere after this
echo "⚠️  End of script - CHOICE variable captured but NEVER USED" >> "$LOG_FILE"
echo "⚠️  No case statement to process the selection" >> "$LOG_FILE"
echo "⚠️  No action taken based on user's choice" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Variable value: CHOICE='$CHOICE'" >> "$LOG_FILE"
echo "Script exits without processing user selection" >> "$LOG_FILE"
