#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local head="head"
    local file="./inputs/enwik9"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_head "$program_path" "$head" "$file" "$repetition"
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

perform_head() {
    local program_path="$1"
    local head_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/head [OPTION]... [FILE]...
    #   Print the first 10 lines of each FILE to standard output.
    #   With more than one FILE, precede each with a header giving the file name.
    local program="$program_path/$head_command -n 50 $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$head_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
