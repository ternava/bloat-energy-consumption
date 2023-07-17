#!/usr/bin/env bash

# use it for debugging
# set -x

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main() {
    local program_path="$1"
    local md5sum="md5sum"
    local file="./inputs/paper.pdf"

    validate_inputs "$program_path" "$file"

    perform_md5sum "$program_path" "$md5sum" "$file"
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

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../pre-experiment/exe-GNU-v93/md5sum [OPTION]... [FILE]...
    #   Conmd5sumenate FILE(s) to standard output.
    local program="$program_path/$md5sum_command $file"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$md5sum_command' command."
        exit 1
    fi
}

main $@
