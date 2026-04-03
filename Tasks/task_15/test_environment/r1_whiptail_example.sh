#!/bin/bash

CHOICE=$(whiptail --title "Menu" --menu "Choose:" 15 50 4 \
    "1" "Check Disk Space" \
    "2" "Check Memory Usage" \
    "3" "Show Processes" \
    "4" "Exit" 3>&1 1>&2 2>&3)

# ============================================================
# TEST RESULTS
# ============================================================
# Test: Run with TERM=xterm
# Result: whiptail renders a menu with 4 options using ncurses
# - Shows "Menu" title
# - Displays "Choose:" prompt
# - Lists 4 options with arrow key navigation
# - Has <Ok> and <Cancel> buttons
# Status: ✅ PASS - whiptail works, creates interactive menu
#
# Functionality:
# - Arrow keys work for navigation (up/down)
# - Enter selects option
# - Tab switches between list and buttons
# - Escape cancels
#
# Overall: whiptail provides simpler TUI than dialog, arrow key support works
