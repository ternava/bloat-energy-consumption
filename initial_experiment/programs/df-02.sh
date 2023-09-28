#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local df="df"
    local repetition="$2"

    validate_inputs "$program_path"
    perform_df "$program_path" "$df" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local file="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_df() {
    local program_path="$1"
    local df_command="$2"
    local file="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/df [OPTION]... [FILE]...
    #   Show information about the file system on which each FILE resides,
    #   or all file systems by default.
    local program="$program_path/$df_command -h -a -i"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$df_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
