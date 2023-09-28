#!/usr/bin/env bash

# use it for debugging
# set -x

# TO CONSIDER: link program has two identical scripts becuase
# it doesn't require any inputs and has no options

main() {
    local program_path="$1"
    local link="link"
    local file="./inputs/enwik8"
    local file_link="./inputs/enwik8link"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_link "$program_path" "$link" "$file" "$file_link" "$repetition"
    reverse_action "$file_link"
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

perform_link() {
    local program_path="$1"
    local link_command="$2"
    local file="$3"
    local file_link="$4"
    local repetition="$5"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/link FILE1 FILE2
    #    or:  ../inputs/GNU/link OPTION
    #   Call the link function to create a link named FILE2 to an existing FILE1.
    local program="$program_path/$link_command $file $file_link"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$link_command' command."
        exit 1
    fi
}

reverse_action() {
    local file_link=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm -f $file_link
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
