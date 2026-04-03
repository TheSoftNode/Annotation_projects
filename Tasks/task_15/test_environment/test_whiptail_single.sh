#!/bin/bash

# Test what happens with ONE selection in whiptail (default behavior)

LOG_FILE="/tmp/whiptail_test.log"

echo "=== Running whiptail example from Response 1 ===" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# THIS IS THE EXACT CODE FROM RESPONSE 1 - verbatim
CHOICE=$(whiptail --title "Menu" --menu "Choose:" 15 50 4 \
    "1" "Check Disk Space" \
    "2" "Check Memory Usage" \
    "3" "Show Processes" \
    "4" "Exit" 3>&1 1>&2 2>&3)

exit_status=$?

# After whiptail exits, show what we captured
echo "" | tee -a "$LOG_FILE"
echo "=== After whiptail exits ===" | tee -a "$LOG_FILE"
echo "User selected: '$CHOICE'" | tee -a "$LOG_FILE"
echo "Exit status: $exit_status" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "⚠️  Response 1's code STOPS HERE - no processing logic provided" | tee -a "$LOG_FILE"
echo "⚠️  The \$CHOICE variable has a value ('$CHOICE') but is never used" | tee -a "$LOG_FILE"
echo "⚠️  No case statement, no action taken" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "This is INCOMPLETE code - users need to add their own processing" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Log saved to: $LOG_FILE"
