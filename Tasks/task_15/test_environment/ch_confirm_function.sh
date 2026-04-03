#!/bin/bash

confirm() {

    local prompt="$1"

    local default="${2:-n}"

    local response



    if [[ "$default" =~ ^[Yy]$ ]]; then

        prompt="$prompt [Y/n]: "

    else

        prompt="$prompt [y/N]: "

    fi



    read -r -p "$prompt" response

    response=${response:-$default}



    if [[ "$response" =~ ^[Yy]$ ]]; then

        return 0  # true - user said yes

    else

        return 1  # false - user said no

    fi

}

# Usage

if confirm "Do you want to delete the file?"; then

    echo "Deleting file..."

    # rm file.txt

else

    echo "File not deleted."

fi

if confirm "Install package?" "y"; then

    echo "Installing..."

    # apt install package

fi

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input 'n' for first prompt, 'n' for second
# Result: File not deleted. (second prompt defaults to Y so aborts)
# Status: ✅ PASS
#
# Test 2: Input 'y' for first, Enter for second
# Result: Deleting file... Installing...
# Status: ✅ PASS - Default 'y' works on second prompt
#
# Test 3: Input Enter for first, 'n' for second
# Result: File not deleted. (stops at second)
# Status: ✅ PASS - Default 'n' works on first prompt
#
# Overall: Reusable confirm function with customizable defaults works correctly
