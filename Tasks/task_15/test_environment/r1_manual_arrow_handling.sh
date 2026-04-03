#!/bin/bash

# WARNING: This is fragile! Use dialog/fzf instead.

options=("Option 1" "Option 2" "Option 3" "Quit")

selected=0

while true; do

    # Clear screen and redraw menu
    clear

    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            echo "> ${options[$i]}"
        else
            echo "  ${options[$i]}"
        fi
    done

    # Read a single keypress (handles arrows)
    IFS= read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key  # Read next two chars for arrow keys
        case "$key" in
            '[A') ((selected--));; # Up
            '[B') ((selected++));; # Down
        esac
    elif [[ $key == "" ]]; then  # Enter key
        break
    fi

    # Wrap-around selection
    [ $selected -lt 0 ] && selected=$((${#options[@]}-1))
    [ $selected -ge ${#options[@]} ] && selected=0

done

echo "You selected: ${options[$selected]}"

# ============================================================
# TEST RESULTS
# ============================================================
# Manual Test: Run interactively and test arrow keys
# Result: Pure bash arrow key handling works
# - Clears screen and redraws menu
# - Shows "> " next to selected option
# - Reads escape sequences for arrow keys
# - Wrap-around when going past first/last option
# Status: ✅ PASS - Arrow key navigation works in pure bash
#
# Functionality:
# - Up arrow ([A) decrements selected
# - Down arrow ([B) increments selected
# - Enter key breaks loop
# - Wrap-around: going up from 0 goes to last, down from last goes to 0
#
# Caveats (as noted in comment):
# - Fragile and complex
# - Requires reading raw ANSI escape sequences
# - No ESC key handling, no resize handling
# - Better to use dialog/fzf/whiptail
#
# Overall: Proves arrow keys CAN be handled in pure bash but it's complex
