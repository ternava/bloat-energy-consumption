#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local cut="cut"
    local large_file="./inputs/CVD_cleaned.csv"
    local repetition="$2"

    validate_inputs "$program_path" "$large_file"
    perform_cut "$program_path" "$cut" "$large_file" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local large_file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$large_file" ]
    then
        echo "The source file '$large_file' does not exist."
        exit 1
    fi
}

perform_cut() {
    local program_path="$1"
    local cut_command="$2"
    local large_file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: cut OPTION... [FILE]...
    #   Print selected parts of lines from each FILE to standard output.
    local program="$program_path/$cut_command -c 3-5 $large_file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cut_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
