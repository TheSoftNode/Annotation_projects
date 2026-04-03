#!/bin/bash

# The user can select with arrows (or Tab) and hit Enter

option=$(echo -e "Option 1\nOption 2\nOption 3" | fzf --height=10 --border --prompt="Select an option: ")

case $option in
    "Option 1") echo "You chose Option 1" ;;
    "Option 2") echo "You chose Option 2" ;;
    "Option 3") echo "You chose Option 3" ;;
    *) echo "Nothing selected" ;;
esac

# ============================================================
# TEST RESULTS
# ============================================================
# Manual Test: Run interactively
# Result: fzf displays fuzzy search interface
# - Uses echo -e with \n to create list
# - Shows 3 options with border
# - Prompt: "Select an option: "
# - Height limited to 10 lines
# Status: ✅ PASS - fzf works correctly
#
# Functionality:
# - Arrow keys navigate options
# - Type to filter (fuzzy search)
# - Tab also works for navigation
# - Enter selects
# - Escape/Ctrl+C returns empty (matches * case)
#
# Overall: Simpler fzf example than R1, uses echo -e instead of printf
