#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local cat="cat"
    local file="./test-inputs/align-cat.sh"

    validate_inputs "$program_path" "$file"

    perform_cat "$program_path" "$cat" "$file"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f $file ]
    then
        echo "The source file '$file' does not exist."
        exit 1
    fi
}

perform_cat() {
    local program_path="$1"
    local cat_command="$2"
    local file="$3"

    # Usage: ../pre-experiment/exe-GNU-v93/cat [OPTION]... [FILE]...
    #   Concatenate FILE(s) to standard output.
    "$program_path/$cat_command" -vet "$file" > /dev/null 2>&1
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cat_command' command."
        exit 1
    fi
}

main "$@"
