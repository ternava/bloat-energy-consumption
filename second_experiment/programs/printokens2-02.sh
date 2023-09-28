#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local printtoken="printtokens2_p0.2train"
    if [ "$program_path" = "../inputs/bloated" ]; then
        printtoken=${printtoken%%_*}
    fi
    local source="./small_inputs/newtst376.tst"

    validate_inputs "$program_path" "$source"
    perform_printtoken "$program_path" "$printtoken" "$source"
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

perform_printtoken() {
    local program_path="$1"
    local printtoken_command="$2"
    local source="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/printtoken [OPTION]... [FILE]...
    #    or:  ../inputs/exe-GNU-v93/printtoken [OPTION]... --files0-from=F
    #       Write printtokened concatenation of all FILE(s) to standard output.
    local program="$program_path/$printtoken_command $source"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$printtoken_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
