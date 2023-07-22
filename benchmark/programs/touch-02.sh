#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local touch="touch"
    local input_file="./outputs/touch02.txt"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_touch "$program_path" "$touch" "$input_file" "$repetition"
    reverse_action "$input_file"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_touch() {
    local program_path="$1"
    local touch_command="$2"
    local input_file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ./exe-GNU-v93/touch [OPTION]... FILE...
    local program="$program_path/$touch_command -a $input_file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$touch_command' command."
        exit 1
    fi
}

reverse_action() {
    local input_file=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm -f $input_file
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
