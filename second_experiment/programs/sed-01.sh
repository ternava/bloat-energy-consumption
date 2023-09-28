#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local sed="sed-4.1.5_p0.1train"
    if [ "$program_path" = "../pre-experiment/bloated" ]; then
        sed=${sed%%_*}
    fi
    local source1="./small_inputs/scr/s93_0.sed"
    local source2="./small_inputs/default.in"

    validate_inputs "$program_path" "$source1" "$source2"
    perform_sed "$program_path" "$sed" "$source1" "$source2" 
}

validate_inputs() {
    local program_path="$1"
    local source1="$2"
    local source2="$3"


    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$source1" ]
    then
        echo "The source file '$source1' does not exist."
        exit 1
    fi

    if [ ! -f "$source2" ]
    then
        echo "The source file '$source2' does not exist."
        exit 1
    fi

}

perform_sed() {
    local program_path="$1"
    local sed_command="$2"
    local source1="$3"
    local source2="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../pre-experiment/exe-GNU-v93/sort [OPTION]... [FILE]...
    #    or:  ../pre-experiment/exe-GNU-v93/sort [OPTION]... --files0-from=F
    #       Write sorted concatenation of all FILE(s) to standard output.
    local program="$program_path/$sed_command -f $source1 $source2"
    echo "$program"
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$sed_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
