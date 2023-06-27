#!/usr/bin/env bash

# use it for debugging
set -x

main() {
    local program_path="$1"
    local sort="sort"
    local source="./test-inputs/enwik8"

    validate_inputs "$program_path" "$source"

    perform_sort "$program_path" "$sort" "$source"
}

validate_inputs() {
    local program_path="$1"
    local source="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$source" ]
    then
        echo "The source file '$source' does not exist."
        exit 1
    fi
}

perform_sort() {
    local program_path="$1"
    local sort_command="$2"
    local source="$3"

    # Usage: ../pre-experiment/exe-GNU-v93/sort [OPTION]... [FILE]...
    #    or:  ../pre-experiment/exe-GNU-v93/sort [OPTION]... --files0-from=F
    #       Write sorted concatenation of all FILE(s) to standard output.
    "$program_path/$sort_command" "$source" > /dev/null 2>&1
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$sort_command' command."
        exit 1
    fi
}

main "$@"
