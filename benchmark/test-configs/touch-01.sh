#!/usr/bin/env bash

program_path="$1"
touch="touch"
input_file="./test-inputs/touch01.txt"

if [ ! -e "$program_path" ]
then
    echo "The program path '$program_path' does not exists."
    exit 1
fi

# Usage: ./exe-GNU-v93/touch [OPTION]... FILE...


"$program_path/$touch" "$input_file"
