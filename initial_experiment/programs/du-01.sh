#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local du="du"
    local path_to_directory="./inputs/debian"
    local repetition="$2"

    validate_inputs "$program_path" "$path_to_directory"
    perform_du "$program_path" "$du" "$path_to_directory" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local path_to_directory="$2"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -d "$path_to_directory" ]
    then
        echo "The input directory '$path_to_directory' does not exist."
        exit 1
    fi
} 

perform_du() {
    local program_path="$1"
    local du_command="$2"
    local path_to_directory="$3"
    local repetition="$4"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Example: "sudo ../src/jouleit.sh -n 1 ../inputs/exe-ToyBox-v089/wc ./test-inputs/align.sh" 

    # Usage: du [OPTION]... [FILE]...
    #    or:  du [OPTION]... --files0-from=F
    #    Summarize disk usage of the set of FILEs, recursively for directories.
    local programs="$program_path/$du_command $path_to_directory"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"
    
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$du_command' command."
        exit 1
    fi  
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main "$@"
