#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    # The path to the program (for now, we change them here): 
    # "../inputs/BusyBox"
    # "../inputs/ToyBox"
    # "../inputs/GNU"
    local the_script="$1"
    local program_path="$2"
    local repetition="$3"

    # Be carefull when using this next function, 
    # because it makes the nested script run, 
    # in that case the function after it will show an "error".
    # catch_errors_from_the_nested_script "$the_script" "$program_path"
    
    # We call the script with a particular test of a program
    "$the_script" "$program_path" "$repetition"
}

# This function should be used carefully, only for debugging reasons
catch_errors_from_the_nested_script() {
    local script_path="$1"
    local program_path="$2"

    # Call the script and redirect stderr to stdout
    output="$("$script_path" "$program_path" 2>&1)"

    # Check if the script returned an error
    if [[ $? -ne 0 ]]
    then
        echo "An error occurred while executing '$script_path':"
        echo "$output"
        exit 1
    fi
}

main "$@"
