#!/bin/bash

PS3=$'\nSelect operation: '

echo "System Administration Menu"

select task in \

    "Check disk space" \

    "Check memory usage" \

    "Check running processes" \

    "Check network connections" \

    "Exit"; do



    case $task in

        "Check disk space")

            df -h

            ;;

        "Check memory usage")

            free -h

            ;;

        "Check running processes")

            ps aux | head -20

            ;;

        "Check network connections")

            netstat -tulpn

            ;;

        "Exit")

            echo "Goodbye!"

            break

            ;;

        *)

            echo "Invalid option. Please select 1-5."

            ;;

    esac



    echo

    echo "System Administration Menu"

done

# ============================================================
# TEST RESULTS
# ============================================================
# ❌ SYNTAX ERROR IN ORIGINAL CODE
# Error: syntax error near unexpected token `newline'
# Line 7-8: select task in \
#
# Issue: The backslash line continuation is followed by blank lines
# which causes bash to interpret it as incomplete command
#
# The code as shown in the CONVERSATION HISTORY has a formatting
# issue that prevents it from executing. This needs to be noted
# as an Area of Improvement in the conversation history section.
#
# Status: ❌ FAIL - Code does not execute as written
