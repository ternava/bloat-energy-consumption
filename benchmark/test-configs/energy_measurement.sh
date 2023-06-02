#!/usr/bin/env bash

if [[ $# -ne 2 ]]
then 
    echo "Usage: $0 <programpath> <thetest>"
fi

program_path=$1 # e.g., "./pre-experiment/exe-GNU-v93"
the_test=$2     # e.g., "./wc-02.sh"

juleit="../src/jouleit.sh"

if [ -z "$the_test" ] || [ -z "$program_path" ]
then
  echo "Error: Missing required inputs. Check the 'Usage'."
  exit 1
fi

# Continue with the measurement of the energy consumption
sudo "$juleit" -n 1 "$the_test" "$program_path"
