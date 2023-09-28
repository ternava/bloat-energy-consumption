#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local sort="sort"
    local source="./inputs/enwik9"
    local repetition="$2"

    validate_inputs "$program_path" "$source"
    perform_sort "$program_path" "$sort" "$source" "$repetition"
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
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/sort [OPTION]... [FILE]...
    #    or:  ../inputs/exe-GNU-v93/sort [OPTION]... --files0-from=F
    #       Write sorted concatenation of all FILE(s) to standard output.
    local program="$program_path/$sort_command $source"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$sort_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
