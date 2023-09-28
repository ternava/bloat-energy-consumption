#!/usr/bin/env bash

# use it for debugging
#set -x

main() {
    local program_path="$1"
    local id="id"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_id "$program_path" "$id" "$repetition"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_id() {
    local program_path="$1"
    local id_command="$2"
    local repetition="$3"
    
    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/id [ignored command line arguments]
    #   or:  ../inputs/GNU/id OPTION
    # Print user and group information for each specified USER, or (when USER omitted) for the current user.
    #   Exit with a status code indicating failure.
    local program="$program_path/$id_command -u -n"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$id_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
