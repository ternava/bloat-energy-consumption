#!/usr/bin/env bash

if [[ $# -ne 2 ]]
then 
    echo "Usage: $0 <programpath> <thetest>"
fi

program_path=$1 # e.g., "./inputs/exe-GNU-v93"
the_test=$2     # e.g., "./wc-02.sh"

juleit="../src/jouleit.sh"

if [ -z "$the_test" ] || [ -z "$program_path" ]
then
  echo "Error: Missing required inputs. Check the 'Usage'."
  exit 1
fi

# Continue with the measurement of the energy consumption
# e.g., ./test-configs/energy_measurement.sh ../inputs/exe-ToyBox-v089 ./test-configs/wc-02.sh
# basically, we call a specific test/example and send as argument the path of the program that we want it to run
sudo "$juleit" -n 10 "$the_test" "$program_path"
