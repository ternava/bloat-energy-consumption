#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local chown="chown"
    local input_path="./inputs/"

    validate_inputs "$program_path" "$input_path"
    perform_chown "$program_path" "$chown" "$input_path"
    reverse_action "$input_path"
}

validate_inputs() {
    local program_path="$1"
    local input_path="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -e "$input_path" ]
    then
        echo "The input path '$input_path' does not exist."
        exit 1
    fi
}

perform_chown() {
    local program_path="$1"
    local chown_command="$2"
    local input_path="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/chown [OPTION]... [OWNER][:[GROUP]] FILE...
    #    or:  ../inputs/GNU/chown [OPTION]... --reference=RFILE FILE...
    # Change the owner and/or group of each FILE to OWNER and/or GROUP.
    local program="$program_path/$chown_command -Rcv root $input_path"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$chown_command' command."
        exit 1
    fi
}

reverse_action() {
    local input_path=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    sudo chown xternava "$input_path"
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
