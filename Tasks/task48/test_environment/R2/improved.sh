#!/bin/bash

# Purpose: Perform basic arithmetic operations (+, -, *, /)

read -p "Enter first number: " number1
read -p "Enter second number: " number2
read -p "Enter operation (+, -, *, /): " operation

# Validate integers
if ! [[ "$number1" =~ ^-?[0-9]+$ ]] || ! [[ "$number2" =~ ^-?[0-9]+$ ]]; then
  echo "Error: Both numbers must be integers."
  exit 1
fi

case "$operation" in
  "+")
    result=$((number1 + number2))
    echo "Result: $result"
    ;;
  "-")
    result=$((number1 - number2))
    echo "Result: $result"
    ;;
  "*")
    result=$((number1 * number2))
    echo "Result: $result"
    ;;
  "/")
    if [ "$number2" -eq 0 ]; then
      echo "Error: Cannot divide by zero."
    else
      result=$((number1 / number2))
      echo "Result: $result"
    fi
    ;;
  *)
    echo "Invalid operation. Use +, -, *, or /"
    ;;
esac
