#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local sed="sed-4.1.5_p0.3train"
    if [ "$program_path" = "../inputs/bloated" ]; then
        sed=${sed%%_*}
    fi
    local source1="./small_inputs/default.in"

    validate_inputs "$program_path" "$source1" 
    perform_sed "$program_path" "$sed" "$source1" 
}

validate_inputs() {
    local program_path="$1"
    local source1="$2"


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


}

perform_sed() {
    local program_path="$1"
    local sed_command="$2"
    local source1="$3"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/sort [OPTION]... [FILE]...
    #    or:  ../inputs/exe-GNU-v93/sort [OPTION]... --files0-from=F
    #       Write sorted concatenation of all FILE(s) to standard output.
    local program="$program_path/$sed_command -e 's/dog/cat/; =' $source1"
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
