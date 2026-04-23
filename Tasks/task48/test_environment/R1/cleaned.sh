#!/usr/bin/env bash
# ------------------------------------------------------------
# Simple calculator – supports + - * /  (integer + optional float)
# ------------------------------------------------------------

# ---- Helper functions ------------------------------------------------
error_exit() { echo "Error: $1" >&2; exit 1; }

read_int() {
    local prompt="$1"
    while :; do
        read -rp "$prompt" val
        # allow leading/trailing whitespace, reject empty input
        [[ -z $val ]] && continue
        # check that it consists only of optional sign + digits
        [[ $val =~ ^[+-]?[0-9]+$ ]] && echo "$val" && return
        echo "Please enter a valid integer."
    done
}

read_operator() {
    local prompt="$1"
    while :; do
        read -rp "$prompt" op
        case "$op" in
            +|-|/|\*) echo "$op" && return ;;
        esac
        echo "Please enter one of + - * /"
    done
}

# ---- Main script ------------------------------------------------------
num1=$(read_int "Enter first number: ")
num2=$(read_int "Enter second number: ")
op=$(read_operator "Enter operation (+ - * /): ")

# ---- Division needs special handling -----------------------------------
if [[ $op == / ]]; then
    if [[ $num2 -eq 0 ]]; then
        error_exit "Cannot divide by zero."
    fi
    # ---- Option A: integer division (default) -------------------------
    result=$((num1 / num2))
    echo "$result"
    exit 0

    # ---- Option B: floating-point division (uncomment) ---------------
    # result=$(bc -l <<< "scale=4; $num1 / $num2")
    # echo "$result"
    # exit 0
fi

# ---- Handle the other three operations --------------------------------
case "$op" in
    +) result=$((num1 + num2)) ;;
    -) result=$((num1 - num2)) ;;
    *) # This should never happen because read_operator forces a valid op
       error_exit "Invalid operation: $op" ;;
esac

echo "$result"
exit 0
