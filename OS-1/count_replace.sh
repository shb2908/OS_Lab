#!/bin/bash

# Check if a file name was provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Assign the first argument as the file name
filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi

# Display the menu
echo "Choose an option:"
echo "1. Search for a word"
echo "2. Replace a word"
read -p "Enter your choice (1 or 2): " choice

# Perform the selected operation
case $choice in
    1)
        # Search for a word
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
        ;;
    
    2)
        # Replace a word
        read -p "Enter the word to search for: " search_word
        
        # Search the file for the word and count occurrences
        total_occurrences=$(grep -o -w "$search_word" "$filename" | wc -l)
        
        # Check if the word was found
        if [ $total_occurrences -eq 0 ]; then
            echo "The word '$search_word' was not found in the file."
            exit 0
        fi
        
        echo "The word '$search_word' was found $total_occurrences times in the file."
        
        # Ask the user for the word to replace the searched word
        read -p "Enter the word to replace '$search_word' with: " replace_word
        
        # Replace the word in the file
        sed -i "s/\b$search_word\b/$replace_word/g" "$filename"
        
        # Verify the replacement
        if grep -q -w "$replace_word" "$filename"; then
            echo "The word '$search_word' has been successfully replaced with '$replace_word'."
        else
            echo "Failed to replace the word."
        fi
        ;;
    
    *)
        echo "Invalid choice. Please select 1 or 2."
        exit 1
        ;;
esac
