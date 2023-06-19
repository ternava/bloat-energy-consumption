#!/usr/bin/env bash

program_path="$1"
mv="mv"
source="./test-inputs/largefolder.zip"
destination="./test-outputs/"

if [ ! -e "$program_path" ] || [ ! -e "$source" ] || [ ! -e "$destination" ]
then
    echo "The program path '$program_path' or '$source' or '$destination' does not exists."
    exit 1
fi

# Usage: ../pre-experiment/exe-GNU-v93/mv [OPTION]... [-T] SOURCE DEST
#    or:  ../pre-experiment/exe-GNU-v93/mv [OPTION]... SOURCE... DIRECTORY
#    or:  ../pre-experiment/exe-GNU-v93/mv [OPTION]... -t DIRECTORY SOURCE...

"$program_path/$mv" "$source" "$destination"