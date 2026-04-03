#!/bin/bash

# Test script for AOI #1: Professional Menu with missing handlers
# Claim: Options 3 and 4 have no case handlers

LOG_FILE="/tmp/dialog_menu_test.log"
echo "=== Dialog Professional Menu Test - $(date) ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

iteration=0

while true; do
    ((iteration++))
    echo "[Iteration $iteration] Displaying menu..." >> "$LOG_FILE"

    choice=$(dialog --clear \
        --title "System Admin Menu" \
        --menu "Choose an action:" 20 60 12 \
        1 "View System Info" \
        2 "Manage Users" \
        3 "Network Tools" \
        4 "Disk Utilities" \
        5 "Exit" \
        3>&1 1>&2 2>&3)

    exit_status=$?
    echo "[Iteration $iteration] User selected: '$choice' (exit status: $exit_status)" >> "$LOG_FILE"

    case $choice in
        1)
            echo "[Iteration $iteration] Executing handler for option 1 (View System Info)" >> "$LOG_FILE"
            dialog --title "System Info" --msgbox "$(uname -a)" 10 50
            echo "[Iteration $iteration] Completed handler for option 1" >> "$LOG_FILE"
            ;;
        2)
            echo "[Iteration $iteration] Executing handler for option 2 (Manage Users)" >> "$LOG_FILE"
            dialog --title "User Management" --inputbox "Enter username:" 8 40 2>&1 >/dev/tty
            echo "[Iteration $iteration] Completed handler for option 2" >> "$LOG_FILE"
            ;;
        5)
            echo "[Iteration $iteration] Executing handler for option 5 (Exit)" >> "$LOG_FILE"
            clear
            echo "Goodbye!"
            echo "[Iteration $iteration] Exiting program" >> "$LOG_FILE"
            echo "" >> "$LOG_FILE"
            echo "=== FINAL LOG SUMMARY ===" >> "$LOG_FILE"
            echo "Total iterations: $iteration" >> "$LOG_FILE"
            exit 0
            ;;
        *)
            echo "[Iteration $iteration] ⚠️  NO HANDLER FOUND for choice '$choice' - falling through to loop restart" >> "$LOG_FILE"
            ;;
    esac

    echo "[Iteration $iteration] End of case statement, looping back..." >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

done
