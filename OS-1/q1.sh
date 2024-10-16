#!/bin/bash

# Ask user for input
read -p "Enter value for uv1: " uv1
read -p "Enter value for uv2: " uv2

# (a) Print variables in reverse order
reverse_print() {
    echo $1 | rev
}

echo "Reversed uv1: $(reverse_print "$uv1")"
echo "Reversed uv2: $(reverse_print "$uv2")"

# (b) Try to add the two variables
add_variables() {
    if [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]] && [[ "$2" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        sum=$(echo "$1 + $2" | bc)
        echo "Sum of uv1 and uv2: $sum"
    else
        echo "Error: Cannot add the variables. Both must be numeric."
    fi
}

add_variables "$uv1" "$uv2"