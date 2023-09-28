#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local ls="ls"
    local path_to_directory="./inputs/debian"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_ls "$program_path" "$ls" "$path_to_directory" "$repetition"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_ls() {
    local program_path="$1"
    local ls_command="$2"
    local path_to_directory="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/ls [OPTION]... [FILE]...
    # List information about the FILEs (the current directory by default).
    # Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.
    local program="$program_path/$ls_command -Ral $path_to_directory"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$ls_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"



