#!/usr/bin/env bash

if [[ $# -ne 2 ]]
then
    echo "Usage: $0 <sourcefolder> <outputfile>"
fi

# Source folder containing the programs
source_folder=$1
# CSV output file
output_file=$2

# If output file doesn't exists then create it
if [ ! -f "$output_file" ]
then
    touch "$output_file"
fi

# Check if the output file has a .csv extension
if [[ ! "$output_file" =~ \.csv$ ]]
then
    echo "Output file should have a .csv extension."
    exit 1
fi

# Create or overwrite the output file with header
echo "Program;Size" > "$output_file"

# Iterate over the files in the source folder
for file in "$source_folder"/*
do
    # Check if the file is executable
    if [ -x "$file" ]
    then
        # Get the program name without the path
        program_name=$(basename "$file")
        # Get the binary size in bytes
        binary_size=$(stat -c%s "$file")

        # Append program name and binary size to the output file
        echo "$program_name;$binary_size" >> "$output_file"
    fi
done