#!/usr/bin/env bash

# Read inputs (you could add -p prompts if you like)
read -r number1
read -r number2
read -r operation

# Validate that the first two arguments are integers
re='^[+-]?[0-9]+$'
[[ $number1 =~ $re ]] || { echo "First value must be an integer."; exit 1; }
[[ $number2 =~ $re ]] || { echo "Second value must be an integer."; exit 1; }

# Perform the requested operation
case "$operation" in
    "+") result=$((number1 + number2)) ;;
    "-" ) result=$((number1 - number2)) ;;
    "*" ) result=$((number1 * number2)) ;;
    "/" )
        if (( number2 == 0 )); then
            echo "Error: Cannot divide by zero."
            exit 1
        fi
        result=$((number1 / number2))   # integer division
        ;;
    *) echo "Invalid choice"
        exit 1 ;;
esac

echo "$result"
exit 0
