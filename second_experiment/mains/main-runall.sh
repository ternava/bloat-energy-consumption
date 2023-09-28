#!/usr/bin/env bash

# set -x

# These are the three possible program paths, for 3 sets of utilities
program_paths=(
    "../inputs/debloated/chisel"
    "../inputs/debloated/debop"
    "../inputs/debloated/cov"
    "../inputs/bloated"
)

main="./mains/main-runone.sh"
folder_with_programs="./programs"

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
            "$main" "$program" "$program_path"
            echo "Completed $main $program $program_path."
        fi
    done

done