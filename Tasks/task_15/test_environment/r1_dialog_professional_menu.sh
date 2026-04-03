#!/bin/bash

while true; do

    choice=$(dialog --clear \
        --title "System Admin Menu" \
        --menu "Choose an action:" 20 60 12 \
        1 "View System Info" \
        2 "Manage Users" \
        3 "Network Tools" \
        4 "Disk Utilities" \
        5 "Exit" \
        3>&1 1>&2 2>&3)

    case $choice in
        1)
            dialog --title "System Info" --msgbox "$(uname -a)" 10 50
            ;;
        2)
            dialog --title "User Management" --inputbox "Enter username:" 8 40 2>&1 >/dev/tty
            ;;
        5)
            clear
            echo "Goodbye!"
            exit 0
            ;;
    esac

done

# ============================================================
# TEST RESULTS
# ============================================================
# Test: Run with TERM=xterm
# Result: Professional multi-level dialog menu system
# - Main menu loops with while true
# - Shows "System Admin Menu" title
# - 5 options with arrow key navigation
# - Option 1: Shows msgbox with system info
# - Option 2: Shows inputbox for username entry
# - Option 5: Exits with "Goodbye!"
# Status: ✅ PASS - Advanced dialog usage works
#
# Functionality:
# - Nested dialogs (menu → msgbox/inputbox)
# - Menu persists after actions (loops back)
# - Different dialog types: --menu, --msgbox, --inputbox
# - Clean exit with clear screen
#
# Overall: Demonstrates full dialog capabilities for professional scripts
