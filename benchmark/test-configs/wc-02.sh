#!/usr/bin/env bash

program_path="$1"
wc="wc"
input_file="../benchmark/test-inputs/align.sh"

# If the input file does not exist, exit
if [ ! -e "$input_file" ]
then
    echo "Input file '$input_file' does not exist."
    exit 1
fi

# Example/Test 02: program + configuration options + input
# Program: it's as a variable because one of the three implementation of it can be called
# Options: the configuration options should be the same for each call/ version of the program
# Input: an input, if required, and it can be variable, here is fixed
"$program_path/$wc" -mlwc "$input_file"