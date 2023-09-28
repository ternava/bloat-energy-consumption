#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local wc="wc"
    local input_file="./inputs/enwik9"
    local repetition="$2"

    validate_inputs "$program_path" "$input_file"
    perform_wc "$program_path" "$wc" "$input_file" "$repetition"
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
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/wc [OPTION]... [FILE]...
    #    or:  ../inputs/GNU/wc [OPTION]... --files0-from=F
    #   Print newline, word, and byte counts for each FILE, and a total line if
    #   more than one FILE is specified.  A word is a non-zero-length sequence of
    #   printable characters delimited by white space.
    local program="$program_path/$wc_command -mlwc $input_file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
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
