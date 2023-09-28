#!/usr/bin/env bash

# use it for debugging
# set -x

main() {
    local program_path="$1"
    local comm="comm"
    local first_file="./inputs/enwik8"
    local second_file="./inputs/enwik9"
    local repetition="$2"

    validate_inputs "$program_path" "$first_file" "$second_file"
    perform_comm "$program_path" "$comm" "$first_file" "$second_file" "$repetition"
}

validate_inputs() {
    local program_path="$1"
    local file1="$2"
    local file2="$3"

    if [ ! -e "$program_path" ]
    then
        echo "The program path '$program_path' does not exist."
        exit 1
    fi

    if [ ! -f "$file1" ] || [ ! -f "$file2" ]
    then
        echo "One or both source files '$file1', '$file2' do not exist."
        exit 1
    fi
}

perform_comm() {
    local program_path="$1"
    local comm_command="$2"
    local file1="$3"
    local file2="$4"
    local repetition="$5"

    local file1_srt="./outputs/enwik8_sorted.txt"
    local file2_srt="./outputs/enwik9_sorted.txt"

    outputfile="$(basename "$0" .sh)_$(basename "$program_path")"

    # Input files first need to be sorted:
    sort $file1 -o $file1_srt
    sort $file2 -o $file2_srt

    # Usage: ../inputs/GNU/comm [OPTION]... FILE1 FILE2
    #   Compare sorted files FILE1 and FILE2 line by line.
    local program="$program_path/$comm_command $file1_srt $file2_srt"
    $JOULEIT -o "$repetition/$outputfile.csv" "./mains/wrapper.sh" "$program"

    reverse_action "$file1_srt" "$file2_srt"

    local exit_status=$?

    if [ $exit_status -ne 0 ]
    then
        echo "Error occurred while executing '$program_path/$comm_command' command."
        exit 1
    fi

}

reverse_action() {
    local input_file1=$1
    local input_file2=$2
    ##########################################################
    # In this part, we reverse the action, for the next execution
    rm "$input_file1" "$input_file2"
    ##########################################################
}

# The command calling the script for measuring 
# the energy consumption of a program (given in a second script)
JOULEIT="sudo ../src/jouleit.sh -n 1"

main $@
