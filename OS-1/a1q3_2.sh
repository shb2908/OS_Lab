#!/bin/bash

# Function to list ordinary files with relative paths
list_files() {
  local dir="$1"
  (cd "$dir" && find . -type f)
}

# Function to count directories
count_directories() {
  local dir="$1"
  find "$dir" -type d | wc -l
}

# Get the current working directory
current_dir=$(pwd)

# List the ordinary files with relative paths and count them
file_list=$(list_files "$current_dir")
file_count=$(echo "$file_list" | wc -l)

# Count the number of directories
directory_count=$(count_directories "$current_dir")

# Print the results
echo "Number of ordinary files in '$current_dir' and its sub-directories: $file_count"
echo "List of ordinary files (relative paths):"
echo "$file_list"

echo ""
echo "Number of directories (including sub-directories) in '$current_dir': $directory_count"
