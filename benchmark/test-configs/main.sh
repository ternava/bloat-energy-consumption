#!/usr/bin/env bash

set -x

main() {
    # The path to the program (for now, we change them here): 
    # "../pre-experiment/exe-BusyBox-1360-final"
    # "../pre-experiment/exe-ToyBox-v089"
    # "./pre-experiment/exe-GNU-v93"
    local program_path="../pre-experiment/exe-ToyBox-v089"
    local the_script="$1"

    #catch_errors_from_the_nested_script "$the_script" "$program_path"
    measure_energy_of_a_program "$the_script" "$program_path"
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

measure_energy_of_a_program() {
    local script_path="$1"
    local program_path="$2"

    $JOULEIT "$script_path" "$program_path"
}

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