#!/usr/bin/env bash

# This script is used to extract all built utilities from GNU, ToyBox, or BusyBox, etc
# Then, it copies them to our new project, with all our experiments

if [[ $# -ne 2 ]]
then
    echo "Usage: $0 <sourcefolderpath> <destinationfolderpath>"
    exit 1
fi

# Source folder containing the executables
source_folder=$1

# Destination folder to export the executables
destination_folder=$2

# Create the destination folder if it doesn't exist
mkdir -p "$destination_folder"

# Loop through all the files in the folder
for file in $source_folder/*
do
    # Check if the file is executable
    if [[ -x "$file" ]]
    then
        # Get the filename without the path
        executable=$(basename "$file")

        # Copy the executable to the destination folder
        cp "$file" "$destination_folder/$executable"
    fi
done