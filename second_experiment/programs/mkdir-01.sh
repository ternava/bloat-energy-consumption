#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local mkdir="mkdir-5.2.1_I0"
    if [ "$program_path" = "../inputs/bloated" ]; then
        mkdir=${mkdir%%_*}
    fi
    local new_dir="./outputs/newdir"
    if [ ! -e "./outputs" ]
    then
    mkdir ./outputs
    fi
    validate_inputs "$program_path"
    perform_mkdir "$program_path" "$mkdir" "$new_dir"
    reverse_action "$new_dir"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_mkdir() {
    local program_path="$1"
    local mkdir_command="$2"
    local new_dir="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/bloated/mkdir-5.2.1 [OPTION]... DIRECTORY...
    # Create the DIRECTORY(ies), if they do not already exist.
    local program="$program_path/$mkdir_command $new_dir"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$mkdir_command' command."
        exit 1
    fi
}

reverse_action() {
    local parent_directory=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm -r $parent_directory
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
