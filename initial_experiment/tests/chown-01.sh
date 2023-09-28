#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local chown="chown"
    local file="./inputs/paper.pdf"

    validate_inputs "$program_path" "$file"
    perform_chown "$program_path" "$chown" "$file"
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

perform_chown() {
    local program_path="$1"
    local chown_command="$2"
    local file="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/chown [OPTION]... [OWNER][:[GROUP]] FILE...
    #    or:  ../inputs/GNU/chown [OPTION]... --reference=RFILE FILE...
    # Change the owner and/or group of each FILE to OWNER and/or GROUP.
    local program="$program_path/$chown_command root $file"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$chown_command' command."
        exit 1
    fi
}

reverse_action() {
    local file=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    sudo chown xternava "$file"
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
