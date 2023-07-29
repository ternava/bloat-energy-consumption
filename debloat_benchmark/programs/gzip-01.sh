#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local zip="gzip-1.3_n10train"
    if [ "$program_path" = "../pre-experiment/bloated" ]; then
        zip=${zip%%_*}
    fi
    local source="./small_inputs/34file"

    validate_inputs "$program_path" "$source"
    perform_zip "$program_path" "$zip" "$source"
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

perform_zip() {
    local program_path="$1"
    local zip_command="$2"
    local source="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../pre-experiment/exe-GNU-v93/zip [OPTION]... [FILE]...
    #    or:  ../pre-experiment/exe-GNU-v93/zip [OPTION]... --files0-from=F
    #       Write ziped concatenation of all FILE(s) to standard output.
    local program="$program_path/$zip_command -c $source"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$zip_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
