#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Usage: $0 filename"
    exit 1
fi


filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi

# Ask the user for a word to search for
read -p "Enter the word to search: " search_word

# Search the file for the word and count occurrences
total_occurrences=$(grep -o -w "$search_word" "$filename" | wc -l)

# Check if the word was found
if [ $total_occurrences -eq 0 ]; then
    echo "The word '$search_word' was not found in the file."
    exit 0
fi

echo "The word '$search_word' was found $total_occurrences times in the file."

# Display line numbers and occurrences per line
grep -n -o -w "$search_word" "$filename" | awk -F: '{count[$1]++} END {for (line in count) print "Line Number: " line " - Occurrences: " count[line]}' | sort -n
