#!/usr/bin/env bash

# use it for debugging
# set -x

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main() {
    local program_path="$1"
    local id="id"

    validate_inputs "$program_path"

    perform_id "$program_path" "$id"
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

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../pre-experiment/exe-GNU-v93/id [OPTION]... [FILE]...
    #   Conidenate FILE(s) to standard output.
    local program="$program_path/$id_command -G"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" $program

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$id_command' command."
        exit 1
    fi
}

main $@
