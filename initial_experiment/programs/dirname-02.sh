#!/usr/bin/env bash

# use it for debugging
# set -x

# TO CONSIDER: dirname program has two almost identical scripts (inputs vary a bit),
# because in two sets of utilities it has no configuration options
# neither it accepts more than 1 path

main() {
    local program_path="$1"
    local dirname="dirname"
    local file="../benchmark/programs/dirname-02.sh"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_dirname "$program_path" "$dirname" "$file" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$file" ]
    then
        echo "The source file '$file' does not exist."
        exit 1
    fi
}

perform_dirname() {
    local program_path="$1"
    local dirname_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/dirname [OPTION] NAME...
    #   Output each NAME with its last non-slash component and trailing slashes
    #   removed; if NAME contains no /'s, output '.' (meaning the current directory).
    local program="$program_path/$dirname_command $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$dirname_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
