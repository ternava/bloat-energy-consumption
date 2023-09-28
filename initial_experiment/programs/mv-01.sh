#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local mv="mv"
    local source="./inputs/largefolder01.zip"
    local destination="./outputs"
    local repetition="$2"

    validate_inputs "$program_path" "$source" "$destination"
    perform_move "$program_path" "$mv" "$source" "$destination" "$repetition"
    reverse_action "$source" "$destination"
}

validate_inputs() {
    local program_path="$1"
    local source="$2"
    local destination="$3"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$source" ]
    then
        echo "The source file '$source' does not exist."
        exit 1
    fi

    if [ ! -d "$destination" ]
    then
        echo "The destination directory '$destination' does not exist."
        exit 1
    fi
}

perform_move() {
    local program_path="$1"
    local mv_command="$2"
    local source="$3"
    local destination="$4"
    local repetition="$5"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/mv [OPTION]... [-T] SOURCE DEST
    #    or:  ../inputs/exe-GNU-v93/mv [OPTION]... SOURCE... DIRECTORY
    #    or:  ../inputs/exe-GNU-v93/mv [OPTION]... -t DIRECTORY SOURCE...
    local program="$program_path/$mv_command $source $destination"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$mv_command' command."
        exit 1
    fi
}

reverse_action() {
    local source=$1 # ./inputs/paper.pdf
    local destination=$2 # outputs 
    ##########################################################
    # In this part, we reverse the action, for the next execution
    filename=$(basename $source)
    to_dir=$(dirname $source)
    mv "$destination/$filename" "$to_dir"
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
