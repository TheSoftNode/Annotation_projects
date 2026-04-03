#!/bin/bash

echo "What would you like to do?"

select option in "Continue" "Skip" "Abort"; do

    case $option in

        "Continue")

            echo "Continuing..."

            break

            ;;

        "Skip")

            echo "Skipping this step..."

            break

            ;;

        "Abort")

            echo "Aborting script."

            exit 1

            ;;

        *)

            echo "Invalid option. Please choose 1, 2, or 3."

            ;;

    esac

done

# Continue with script

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input '1' (Continue)
# Result: Continuing...
# Status: ✅ PASS
#
# Test 2: Input '2' (Skip)
# Result: Skipping this step...
# Status: ✅ PASS
#
# Test 3: Input '3' (Abort)
# Result: Aborting script. (exits)
# Status: ✅ PASS
#
# Overall: select command works correctly with numeric input only
