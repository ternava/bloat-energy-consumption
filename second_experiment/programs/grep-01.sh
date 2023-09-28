#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local grep="grep-2.4.2_p0.2train"
    if [ "$program_path" = "../inputs/bloated" ]; then
        grep=${grep%%_*}
    fi
    local source1="./small_inputs/grep/grep0.dat"
    local source2="./small_inputs/grep/grep1.dat"
    local source3="./small_inputs/grep/grepNull.dat"

    validate_inputs "$program_path" "$source1" "$source2" "$source3"
    perform_grep "$program_path" "$grep" "$source1" "$source2" "$source3"
}

validate_inputs() {
    local program_path="$1"
    local source1="$2"
    local source2="$3"
    local source3="$4"


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

    if [ ! -f "$source3" ]
    then
        echo "The source file '$source3' does not exist."
        exit 1
    fi
}

perform_grep() {
    local program_path="$1"
    local grep_command="$2"
    local source1="$3"
    local source2="$4"
    local source3="$5"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Usage: ../inputs/exe-GNU-v93/sort [OPTION]... [FILE]...
    #    or:  ../inputs/exe-GNU-v93/sort [OPTION]... --files0-from=F
    #       Write sorted concatenation of all FILE(s) to standard output.
    local program="$program_path/$grep_command -E 'Include|n{1}.lude' $source1 $source2 $source3"
    echo $program
    $JOULEIT -o "$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$grep_command' command."
        exit 1
    fi
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
