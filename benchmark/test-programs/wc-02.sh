#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local wc="wc"
    local input_file="./test-inputs/align.sh"

    validate_inputs "$program_path" "$input_file"

    perform_wc "$program_path" "$wc" "$input_file"
}

validate_inputs() {
    local program_path="$1"
    local input_file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$input_file" ]
    then
        echo "The input file '$input_file' does not exist."
        exit 1
    fi
} 

perform_wc() {
    local program_path="$1"
    local wc_command="$2"
    local input_file="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Example: "sudo ../src/jouleit.sh -n 1 ../pre-experiment/exe-ToyBox-v089/wc ./test-inputs/align.sh" 

    # Example/Test 02: program + configuration options + input
    # Program: it's as a variable because one of the three implementation of it can be called
    # Options: the configuration options should be the same for each call/ version of the program
    # Input: an input, if required, and it can be variable, here is fixed
    local program="$program_path/$wc_command -mlwc $input_file"
    $JOULEIT -o "$outputfile.csv" "./test-programs/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$wc_command' command."
        exit 1
    fi  
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"