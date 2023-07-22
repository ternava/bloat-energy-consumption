#!/usr/bin/env bash

# Path to the main script
script_path="./mains/main-runall.sh"
repetitions_path="./repetitions"

# Number of runs
num_runs=10

# Loop to run the script multiple times
for ((i=1; i<=num_runs; i++)); do
    # Create a new folder for each run
    folder_name="repeat$i"
    mkdir "$repetitions_path/$folder_name"
    
    # Execute main_runall.sh and save the output in the new folder
    "$script_path" "$repetitions_path/$folder_name"
done
