#!/usr/bin/env bash

# set -x

# These are the three possible program paths, for 3 sets of utilities
program_paths=(
    "../inputs/GNU"
    "../inputs/BusyBox"
    "../inputs/ToyBox"
)

main="./mains/main-runone.sh"
folder_with_programs="./programs"
folder_with_repetitions="$1"

# Run all experiments once for each program_path
# All programs to run are located in the ./programs/ folder, and only them!
for program_path in "${program_paths[@]}"
do
    echo "Running experiments for program path: $program_path"
    for program in "$folder_with_programs"/*.sh
    do
        echo "$program"
        if [ -f "$program" ] && [ -x "$program" ]
        then
            echo "Executing $main $program $program_path..."
            "$main" "$program" "$program_path" "$folder_with_repetitions"
            echo "Completed $main $program $program_path."
        fi
    done
done
