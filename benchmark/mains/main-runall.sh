#!/usr/bin/env bash

set -x

main="./mains/main-runone.sh"
folder_with_programs="./test-configs"

# Run all experiments once.
# All programs to run are located in the ./test-configs folder
for program in "$folder_with_programs"/*.sh
do
    echo "$program"
    if [ -f "$program" ] && [ -x "$program" ]
    then
        echo "Executing $main $program..."
        "$main" "$program"
        echo "Completed $main $program."
    fi
done


#find "$folder_with_programs" -type f -name "*.sh" -exec sh -c "$main {}" \;