#!/usr/bin/env bash

# use it for debugging
# set -x

# TO CONSIDER: cksum program has two identical scripts, with different inputs only
# because in one set of utilities it has no configuration options

main() {
    local program_path="$1"
    local cksum="cksum"
    local file="./inputs/largefolder01.zip"
    local repetition="$2"

    validate_inputs "$program_path" "$file"
    perform_cksum "$program_path" "$cksum" "$file" "$repetition"
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

perform_cksum() {
    local program_path="$1"
    local cksum_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/cksum [OPTION]... [FILE]...
    #   Print or verify checksums.
    #   By default use the 32 bit CRC algorithm.
    local program="$program_path/$cksum_command $file"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cksum_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
