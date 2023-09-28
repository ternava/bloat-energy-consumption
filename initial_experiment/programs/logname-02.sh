#!/usr/bin/env bash

# use it for debugging
# set -x

# TO CONSIDER: logname program has two identical scripts because
# it doesn't require any inputs and has no options

main() {
    local program_path="$1"
    local logname="logname"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_logname "$program_path" "$logname" "$repetition"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_logname() {
    local program_path="$1"
    local logname_command="$2"
    local repetition="$3"
    
    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/logname [OPTION]
    #   Print the user's login name.
    local program="$program_path/$logname_command"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$logname_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
