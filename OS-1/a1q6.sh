#!/bin/bash

# Check if a filename was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a filename as an argument."
    exit 1
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

# Prompt for the word to search
read -p "Enter the word to search for: " search_word

# Search for the word in the file
if grep -q "$search_word" "$filename"; then
    # Count total occurrences
    total_count=$(grep -o "$search_word" "$filename" | wc -l)
    echo "a) The word '$search_word' appears $total_count time(s) in the file."
    
    echo "b) Line numbers and occurrences:"
    line_number=0
    while IFS= read -r line; do
        line_number=$((line_number + 1))
        count=$(echo "$line" | grep -o "$search_word" | wc -l)
        if [ $count -gt 0 ]; then
            echo "   Line $line_number: $count time(s)"
        fi
    done < "$filename"
else
    echo "The word '$search_word' was not found in the file."
fi