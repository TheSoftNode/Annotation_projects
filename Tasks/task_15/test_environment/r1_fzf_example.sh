#!/bin/bash

options=("Option 1" "Option 2" "Option 3" "Quit")

choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select: " --height=10 --border)

case "$choice" in
    "Option 1") echo "You picked Option 1";;
    "Option 2") echo "You picked Option 2";;
    "Option 3") echo "You picked Option 3";;
    "Quit") exit 0;;
esac

# ============================================================
# TEST RESULTS
# ============================================================
# Manual Test: Run interactively
# Result: fzf displays a fuzzy search interface
# - Shows 4 options in a bordered box
# - Prompt shows "Select: "
# - Height limited to 10 lines
# - Supports arrow keys for navigation
# - Supports fuzzy typing to filter options
# Status: ✅ PASS - fzf works correctly
#
# Functionality:
# - Arrow keys (up/down) navigate options
# - Type characters to filter list (fuzzy search)
# - Enter selects highlighted option
# - Escape/Ctrl+C cancels
#
# Overall: fzf provides modern fuzzy search with arrow keys + type-to-filter
