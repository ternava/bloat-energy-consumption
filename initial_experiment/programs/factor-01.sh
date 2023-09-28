#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local factor="factor"
    local number="123456789"
    local repetition="$2"

    validate_inputs "$program_path" "$number"
    perform_factor "$program_path" "$factor" "$number" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if ! [[ $number =~ ^[0-9]+$ ]]
    then
        echo "The variable '$number' does not contain a number."
    fi
}

perform_factor() {
    local program_path="$1"
    local factor_command="$2"
    local number="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/factor [OPTION] [NUMBER]...
    #   Print the prime factors of each specified integer NUMBER.  If none
    #   are specified on the command line, read them from standard input.
    local program="$program_path/$factor_command $number"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$factor_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
