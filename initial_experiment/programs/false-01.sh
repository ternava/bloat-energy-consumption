#!/usr/bin/env bash

# use it for debugging
#set -x

# TO CONSIDER: false program has two identical scripts becuase
# it doesn't require any inputs and has no options

# ERROR: maybe because of the returned value, the generated .csv has the return status 

main() {
    local program_path="$1"
    local false="false"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_false "$program_path" "$false" "$repetition"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_false() {
    local program_path="$1"
    local false_command="$2"
    local repetition="$3"
    
    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/false [ignored command line arguments]
    #   or:  ../inputs/GNU/false OPTION
    #   Exit with a status code indicating failure.
    local program="$program_path/$false_command"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$false_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
