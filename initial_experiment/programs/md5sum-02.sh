#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local md5sum="md5sum"
    local file="./inputs/checksumstest.txt"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_md5sum "$program_path" "$md5sum" "$file" "$repetition"
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

perform_md5sum() {
    local program_path="$1"
    local md5sum_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/md5sum [OPTION]... [FILE]...
    #   Print or check MD5 (128-bit) checksums.
    local program="$program_path/$md5sum_command -c $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$md5sum_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
