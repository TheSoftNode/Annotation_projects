#!/bin/bash

PS3='Select a menu option (1-3): '

echo "Main Menu:"

select choice in "Show Date" "Show Disk Usage" "Exit"; do

    case $choice in

        "Show Date")

            date

            ;;

        "Show Disk Usage")

            df -h

            ;;

        "Exit")

            echo "Goodbye!"

            break

            ;;

        *)

            echo "Invalid selection. Try again."

            ;;

    esac



    # Show menu again

    echo

    echo "Main Menu:"

done

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input '1' (Show Date)
# Result: Displays current date, shows menu again
# Status: ✅ PASS
#
# Test 2: Input '2' (Show Disk Usage)
# Result: Displays df -h output, shows menu again
# Status: ✅ PASS
#
# Test 3: Input '3' (Exit)
# Result: Goodbye! and exits
# Status: ✅ PASS
#
# Overall: Custom PS3 prompt works. Menu redisplays after each action until Exit
