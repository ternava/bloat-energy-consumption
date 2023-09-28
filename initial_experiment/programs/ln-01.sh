#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local ln="ln"
    local file="./inputs/enwik8"
    local file_ln="./inputs/enwik8ln"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_ln "$program_path" "$ln" "$file" "$file_ln" "$repetition"
    reverse_action "$file_ln"
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

perform_ln() {
    local program_path="$1"
    local ln_command="$2"
    local file="$3"
    local file_ln="$4"
    local repetition="$5"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # sage: ../inputs/GNU/ln [OPTION]... [-T] TARGET LINK_NAME
    #   or:  ../inputs/GNU/ln [OPTION]... TARGET
    #   or:  ../inputs/GNU/ln [OPTION]... TARGET... DIRECTORY
    #   or:  ../inputs/GNU/ln [OPTION]... -t DIRECTORY TARGET...
    #   Create hard links by default, symbolic links with --symbolic.
    local program="$program_path/$ln_command -sfT $file $file_ln"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$ln_command' command."
        exit 1
    fi
}

reverse_action() {
    local file_ln=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm $file_ln
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
