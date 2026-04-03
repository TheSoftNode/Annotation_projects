#!/bin/bash

PS3='Please choose an option: '

select option in "Option 1" "Option 2" "Quit"; do

    case $option in

        "Option 1") echo "You chose Option 1";;

        "Option 2") echo "You chose Option 2";;

        "Quit") break;;

        *) echo "Invalid option";;

    esac

done

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input '1'
# Result: You chose Option 1 (loops back to menu)
# Status: ✅ PASS
#
# Test 2: Input '2'
# Result: You chose Option 2 (loops back to menu)
# Status: ✅ PASS
#
# Test 3: Input '3' (Quit)
# Result: Exits select loop with break
# Status: ✅ PASS
#
# Test 4: Input '4' (invalid)
# Result: Invalid option (loops back)
# Status: ✅ PASS
#
# Overall: PS3 customizes the select prompt correctly. Shows "Please choose an option:" instead of default "#?"
