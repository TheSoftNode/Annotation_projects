#!/bin/bash
# Purpose: Perform basic arithmetic operations (+, -, *, /)
# Ask user for the input

read number1
read number2
read operation

# Check if the operation is valid
if [ "$operation" = "+" ]; then
  result=$((number1 + number2))
  echo "$result"

elif [ "$operation" = "-" ]; then
  result=$((number1 - number2))
  echo "$result"

elif [ "$operation" = "*" ]; then
  result=$((number1 * number2))
  echo "$result"

elif [ "$operation" = "/" ]; then
  if [ "$number2" -eq 0 ]; then
    echo "Error: Cannot divide by zero."
  else
    result=$((number1 / number2))
    echo "$result"
  fi

else
  echo "Invalid choice"
fi
