#!/usr/bin/env bash

if [[ $# -ne 4 ]]
then 
    echo "Usage: $0 <file1> <file2> <file3> <output_file>"
fi

file1=$1
file2=$2
file3=$3
output_file=$4


if [ ! -f "$output_file" ]
then
    touch "$output_file"
fi

#sort "$file1" "$file2" | uniq -d >> "$output_file"

# Find the intersection of utilities in files for three implementations
intersection=$(comm -12 <(sort "$file1") <(sort "$file2") | comm -12 - <(sort "$file3"))

# Print the intersection to standard output
echo "$intersection" >> $output_file