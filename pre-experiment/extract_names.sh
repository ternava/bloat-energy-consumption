#!/usr/bin/env bash

if [[ $# -ne 2 ]]
then 
    echo "Usage: $0 <folder> <output_file>"
fi

folder=$1
output_file=$2

if [ ! -f "$output_file" ]
then
    touch "$output_file"
fi

# Loop through all the files in the folder with utilities
for file in $folder/*
do
    # Check if the file is executable
    if [[ -x "$file" ]]
    then
        # extract the basename of the file
        basename=$(basename "$file")
        # append it to the file
        echo "$basename" >> "$output_file"
    fi
done