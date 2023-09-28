#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local cp="cp"
    local source="./inputs/largefolder01.zip"
    local destination="./outputs"
    local repetition="$2"

    validate_inputs "$program_path" "$source" "$destination"
    perform_cp "$program_path" "$cp" $source "$destination" "$repetition"
    reverse_action "$destination" "$source"
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

    if [ ! -f $source ]
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

perform_cp() {
    local program_path="$1"
    local cp_command="$2"
    local source="$3"
    local destination="$4"
    local repetition="$5"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ./inputs/exe-GNU-v93/cp [OPTION]... [-T] SOURCE DEST
    #    or:  ./inputs/exe-GNU-v93/cp [OPTION]... SOURCE... DIRECTORY
    #    or:  ./inputs/exe-GNU-v93/cp [OPTION]... -t DIRECTORY SOURCE...
    #       Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.
    local program="$program_path/$cp_command -f $source $destination" # >/dev/null 2>&1
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cp_command' command."
        exit 1
    fi
}

reverse_action() {
    local input_folder=$1
    local file_path=$2
    ##########################################################
    # In this part, we reverse the action, for the next execution
    file_basename=$(basename "$file_path")
    rm -f $input_folder/$file_basename
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
