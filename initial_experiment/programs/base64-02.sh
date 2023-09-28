#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local base64="base64"
    local file="./inputs/encoded-panicmonster.png"
    local repetition="$2"
    
    validate_inputs "$program_path" "$file"
    perform_base64 "$program_path" "$base64" "$file" "$repetition"
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

perform_base64() {
    local program_path="$1"
    local base64_command="$2"
    local file="$3"
    local repetition="$4"

    local decoded_file="./outputs/decoded_panicmonster.png"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/base64 [OPTION]... [FILE]
    # Base64 encode or decode FILE, or standard input, to standard output.
    # With no FILE, or when FILE is -, read standard input
    local program="$program_path/$base64_command -d $file > $decoded_file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    reverse_action "$decoded_file"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$base64_command' command."
        exit 1
    fi
}

reverse_action() {
    local decoded_file=$1
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm -f "$decoded_file"
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
