#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local chmod="chmod"
    local file="./inputs/enwik8"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_chmod "$program_path" "$chmod" "$file" "$repetition"
    reverse_action "$file"
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

perform_chmod() {
    local program_path="$1"
    local chmod_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/chmod [OPTION]... MODE[,MODE]... FILE...
    #    or:  ../inputs/GNU/chmod [OPTION]... OCTAL-MODE FILE...
    #    or:  ../inputs/GNU/chmod [OPTION]... --reference=RFILE FILE...
    # Change the mode of each FILE to MODE.
    local program="$program_path/$chmod_command 640 $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$chmod_command' command."
        exit 1
    fi
}

reverse_action() {
    local file=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    chmod u+rw,g+rw,o+r $file
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
