#!/usr/bin/env bash

# use it for debugging
# set -x

# TO CONSIDER: echo program has two identical scripts (input can vary),
# because in one set of utilities it has no configuration options

main() {
    local program_path="$1"
    local echo="echo"
    local file_path="./inputs/checksumstest.txt"
    local input_text=$(<"$file_path")
    local repetition="$2"

    validate_inputs "$program_path" "$input_text"
    perform_echo "$program_path" "$echo" "$input_text" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local input_text="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -n "$input_text" ]
    then
        echo "The input string '$input_text' is empty."
        exit 1
    fi
}

perform_echo() {
    local program_path="$1"
    local echo_command="$2"
    local input_text="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/echo [SHORT-OPTION]... [STRING]...
    #    or:  ../inputs/GNU/echo LONG-OPTION
    #   Echo the STRING(s) to standard output.
    local program="$program_path/$echo_command $input_text"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    # This works but we have to do a proper naming of generated files by Jouleit.
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$echo_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
