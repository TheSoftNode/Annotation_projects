#!/bin/bash

CHOICE=$(dialog --clear \
                --title "System Menu" \
                --menu "Choose an option:" 15 50 4 \
                1 "Check Disk Space" \
                2 "Check Memory Usage" \
                3 "Show Running Processes" \
                4 "Exit" \
                3>&1 1>&2 2>&3)

clear

case $CHOICE in
    1) df -h ;;
    2) free -h ;;
    3) ps aux ;;
    4) exit 0 ;;
esac

# ============================================================
# TEST RESULTS
# ============================================================
# Test: Run with TERM=xterm
# Result: Dialog renders a menu with 4 options using ncurses interface
# - Shows "System Menu" title
# - Displays numbered options 1-4
# - Supports arrow key navigation
# - Has OK and Cancel buttons
# Status: ✅ PASS - dialog command works, creates interactive menu
#
# Functionality:
# - Arrow keys work for navigation (up/down)
# - Enter selects highlighted option
# - Tab switches between menu and buttons
# - Escape cancels
#
# Overall: dialog provides full TUI (Text User Interface) with arrow key support
