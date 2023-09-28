#!/usr/bin/env bash

# use it for debugging
# set -x

# ERROR: This program shows an error with the "expand" command in ToyBox

main() {
    local program_path="$1"
    local expand="expand"
    local file="./inputs/enwik8"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_expand "$program_path" "$expand" "$file" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$file" ]
    then
        echo "The source file '$file' does not exist."
        exit 1
    fi
}

perform_expand() {
    local program_path="$1"
    local expand_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/expand [OPTION]... [FILE]...
    # Convert tabs in each FILE to spaces, writing to standard output.
    local program="$program_path/$expand_command -t 4 $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$expand_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
