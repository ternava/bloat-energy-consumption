#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local cp="cp"
    local source="./test-inputs/largefolder.zip"
    local destination="./test-outputs/"

    validate_inputs "$program_path" "$source" "$destination"

    perform_cp "$program_path" "$cp" $source "$destination"
}

validate_inputs() {
    local program_path="$1"
    local source="$2"
    local destination="$3"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$source" ]
    then
        echo "The source file '$source' does not exist."
        exit 1
    fi

    if [ ! -d "$destination" ]
    then
        echo "The destination directory '$destination' does not exist."
        exit 1
    fi
}

perform_cp() {
    local program_path="$1"
    local cp_command="$2"
    local source="$3"
    local destination="$4"

    # Usage: ./pre-experiment/exe-GNU-v93/cp [OPTION]... [-T] SOURCE DEST
    #    or:  ./pre-experiment/exe-GNU-v93/cp [OPTION]... SOURCE... DIRECTORY
    #    or:  ./pre-experiment/exe-GNU-v93/cp [OPTION]... -t DIRECTORY SOURCE...
    #       Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.
    "$program_path/$cp_command" -R "$source" "$destination" # >/dev/null 2>&1
    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$cp_command' command."
        exit 1
    fi
}

main "$@"
