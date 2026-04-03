#!/bin/bash

# Function to select with arrows

select_arrow() {

    local options=("$@")
    local selected=0
    local last_selected=-1

    # Hide cursor
    tput civis



    while true; do

        # Draw options
        if [[ $selected -ne $last_selected ]]; then

            tput cuu "${#options[@]}" # Move cursor up
            tput ed                   # Clear lines below

            for i in "${!options[@]}"; do

                if [[ $i -eq $selected ]]; then

                    echo -e "\e[1;32m> ${options[$i]}\e[0m" # Highlighted

                else

                    echo "  ${options[$i]}"

                fi

            done

            last_selected=$selected

        fi

        # Read user input
        read -rsn1 input

        case $input in

            A) # Up arrow
                ((selected--)); ((selected < 0)) && selected=$((${#options[@]} - 1)) ;;

            B) # Down arrow
                ((selected++)); ((selected >= ${#options[@]})) && selected=0 ;;

            "") # Enter key
                tput cnorm # Show cursor
                return $selected ;;

        esac

    done

}

options=("Install" "Update" "Remove" "Quit")

echo "Use arrows to select, Enter to confirm:"

# Print options first time to setup layout
for opt in "${options[@]}"; do echo "  $opt"; done

select_arrow "${options[@]}"

result=$?

echo "You selected index $result: ${options[$result]}"

# ============================================================
# TEST RESULTS
# ============================================================
# Manual Test: Run interactively
# Result: Pure bash arrow handling with function encapsulation
# - Defines select_arrow() function for reusability
# - Hides cursor with tput civis
# - Uses tput cuu to move cursor up
# - Uses tput ed to clear lines
# - Green highlight with ANSI codes: \e[1;32m
# - Returns selected index via return $selected
# Status: ✅ PASS - More sophisticated pure bash implementation
#
# Functionality:
# - Up arrow (A) decrements with wrap-around
# - Down arrow (B) increments with wrap-around
# - Enter key returns selection
# - Shows cursor again with tput cnorm before returning
# - Uses $? to capture return value
#
# Improvements over R1's manual handling:
# - Function-based (reusable)
# - Uses tput for cursor manipulation (more robust)
# - Only redraws when selection changes (optimization)
# - Color highlighting for selected item
#
# Overall: More polished pure bash solution, still complex vs external tools
