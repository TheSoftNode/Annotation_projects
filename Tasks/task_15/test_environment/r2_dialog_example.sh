#!/bin/bash

# --menu "Text" height width menu-height

choice=$(dialog --menu "Select an option" 15 50 4 \
    "1" "Check Disk Space" \
    "2" "Check Memory" \
    "3" "Exit" \
    3>&1 1>&2 2>&3 3>&-)

case $choice in
    1) df -h ;;
    2) free -h ;;
    3) clear; exit ;;
esac

# ============================================================
# TEST RESULTS
# ============================================================
# Test: Run with TERM=xterm
# Result: dialog renders menu without --title
# - No title shown (only --menu text)
# - Shows "Select an option" as menu text
# - 3 options with arrow key navigation
# - File descriptor redirection: 3>&1 1>&2 2>&3 3>&-
# Status: ✅ PASS - dialog works
#
# Functionality:
# - Arrow keys navigate
# - Enter selects
# - Simpler than R1 (no --clear, no --title)
#
# Note: Uses `3>&-` to close fd 3 (slightly different from R1's `2>&3`)
#
# Overall: Basic dialog example, works correctly
