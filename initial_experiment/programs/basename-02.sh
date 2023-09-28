#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local basename="basename"
    local input_path="bloat-energy-consumption/benchmark/test-programs/basename-01.sh bloat-energy-consumption/benchmark/programs/basename-02.sh"
    local repetition="$2"

    validate_inputs "$program_path" "$input_path"
    perform_basename "$program_path" "$basename" "$input_path" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local input_path="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -n "$input_path" ]
    then
        echo "The input path '$input_path' is empty."
        exit 1
    fi
}

perform_basename() {
    local program_path="$1"
    local basename_command="$2"
    local input_path="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/basename NAME [SUFFIX]
    #    or:  ../inputs/GNU/basename OPTION... NAME...
    # Print NAME with any leading directory components removed.
    local program="$program_path/$basename_command -a $input_path"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$basename_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
