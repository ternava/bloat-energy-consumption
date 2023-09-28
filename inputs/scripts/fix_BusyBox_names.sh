#!/usr/bin/env bash

if [[ $# -ne 2 ]]
then
    echo "Usage: $0 <originalpath> <destinationpath>"
    exit 1
fi

original_folder=$1
destination_folder=$2

# Create the destination folder if it doesn't exist
mkdir -p "$destination_folder"

# Loop through all the files in the folder with BusyBox executables
for file in $original_folder/*
do
    # Check if the file is executable
    if [[ -x "$file" ]]
    then
        # We run these for BusyBox, to extract only the utility names and make them lowercase
        basename=$(echo "$(basename "$file")" | sed 's/^busybox_//') #'s/^.*_//') 
        # Make the basename lowercase
        basename=$(echo "$basename" | tr '[:upper:]' '[:lower:]')
        echo $basename
        # Copy the executable to the destination folder
        cp "$file" "$destination_folder/$basename"
    fi
done