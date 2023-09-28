#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local date="date"
    local epoch_timestamp=1689590096 # Current epoch timestemp
    local repetition="$2"

    validate_inputs "$program_path"
    perform_date "$program_path" "$date" "$epoch_timestamp" "$repetition"
}

validate_inputs() {
    local program_path="$1"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi
}

perform_date() {
    local program_path="$1"
    local date_command="$2"
    local epoch_timestamp="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/GNU/date [OPTION]... [+FORMAT]
    #    or:  ../inputs/GNU/date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
    #   Display date and time in the given FORMAT.
    local program="$program_path/$date_command -d @$epoch_timestamp +'%Y-%m-%d %H:%M:%S'"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$date_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
