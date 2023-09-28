#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local chmod="chmod"
    local directory="./inputs2/"
    local repetition="$2"

    validate_inputs "$program_path" "$directory"
    perform_chmod "$program_path" "$chmod" "$directory" "$repetition"
    reverse_action "$directory"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -e "$directory" ]
    then
        echo "The path '$directory' does not exist."
        exit 1
    fi
}

perform_chmod() {
    local program_path="$1"
    local chmod_command="$2"
    local direcotry="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/chmod [OPTION]... MODE[,MODE]... FILE...
    #    or:  ../inputs/GNU/chmod [OPTION]... OCTAL-MODE FILE...
    #    or:  ../inputs/GNU/chmod [OPTION]... --reference=RFILE FILE...
    # Change the mode of each FILE to MODE.
    local program="$program_path/$chmod_command -R 640 $direcotry"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$chmod_command' command."
        exit 1
    fi
}

reverse_action() {
    local dir=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    sudo chmod -R u+rw,g+rw,o+r $dir
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
