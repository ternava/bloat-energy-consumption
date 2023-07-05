#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local cut="cut"
    local large_file="./test-inputs/CVD_cleaned.csv"

    validate_inputs "$program_path" "$large_file"

    perform_cut "$program_path" "$cut" "$large_file"
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

    # Usage: cut OPTION... [FILE]...
    #   Print selected parts of lines from each FILE to standard output.
    "$program_path/$cut_command" -d "," -f 1-3 "$large_file" > /dev/null 2>&1
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cut_command' command."
        exit 1
    fi
}

main "$@"
