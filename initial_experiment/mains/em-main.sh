#!/usr/bin/env bash

# set -x

check_arguments() {
    if [[ $# -ne 1 ]]
    then
        # <thecase> presents the specific script with a particular usage of a program
        echo "Error: Please provide one script as argument."
        echo "Usage: $0 <thecase>"
        exit 1
    fi
}

validate_inputs() {
    local thecase_path="$1"
    local theprogram_path="$2"
    local the_juleit="$3"

    if [ -z "$thecase_path" ] || [ ! -f "$thecase_path" ]
    then
        echo "Error: Invalid or missing '$thecase_path' script. Please check the path."
        exit 1
    fi

    if [ ! -e "$theprogram_path" ] || [ ! -e "$the_juleit" ]; then
        echo "The program path '$theprogram_path' and/or '$the_juleit' does not exist."
        exit 1
    fi
}

catch_errors_from_nested_script() {
    local thecase_path="$1"
    local theprogram_path="$2"

    # Call the script and redirect stderr to stdout
    output="$("$thecase_path" "$theprogram_path" 2>&1)"

    # Check if the script returned an error
    if [[ $? -ne 0 ]]
    then
        echo "An error occurred while executing '$thecase_path':"
        echo "$output"
        exit 1
    fi
}

# The measurement of the energy consumption
# e.g., ./test-configs/energy_measurement.sh ../inputs/exe-ToyBox-v089 ./test-configs/wc-02.sh
# basically, we call a specific test/example and send as argument the path of the program that we want it to run
run_thecase_and_measure_energy() {
    local thecase_path="$1"
    local theprogram_path="$2"

    sudo "$juleit" -n 1 "$thecase_path" "$theprogram_path"
}

main() {
    # Checking the number of arguments
    check_arguments "$@"

    # Paths: 
    # "../inputs/exe-BusyBox-1360-final"
    # "../inputs/exe-ToyBox-v089"
    # "./inputs/exe-GNU-v93"
    local program_path="../inputs/exe-ToyBox-v089"
    local the_case="$1"     # e.g., "./wc-02.sh"
    local juleit="../src/jouleit.sh"

    # Checking if inputs exists and are valid
    validate_inputs "$the_case" "$program_path" "$juleit"

    #echo "$program_path $the_case $juleit"
    catch_errors_from_nested_script "$the_case" "$program_path"
    
    run_thecase_and_measure_energy "$the_case" "$program_path"

}

main "$@"

# exit_code=$?
# echo "$exit_code"
# if [[ $exit_code -ne 0 ]]
# then
#     echo "An error occurred: $exit_code"
# fi