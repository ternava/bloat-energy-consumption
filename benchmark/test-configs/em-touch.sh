#!/usr/bin/env bash

if [[ $# -ne 1 ]]
then 
    #echo "Usage: $0 <programpath> <thetest>"
    echo "Usage: $0 <thetest>"
fi

# Paths: 
# "../pre-experiment/exe-BusyBox-1360-final"
# "../pre-experiment/exe-ToyBox-v089"
# "./pre-experiment/exe-GNU-v93"
program_path="../pre-experiment/exe-ToyBox-v089"
the_test=$1     # e.g., "./wc-02.sh"

juleit="../src/jouleit.sh"

if [ -z "$the_test" ] #|| [ -z "$program_path" ]
then
  echo "Error: Missing required inputs. Check the 'Usage'."
  exit 1
fi

if [ ! -e "$program_path" ] || [ ! -e "$juleit" ]
then
    echo "The program path '$program_path' and/or '$juleit' does not exists."
    exit 1
fi

# Continue with the measurement of the energy consumption
# e.g., ./test-configs/energy_measurement.sh ../pre-experiment/exe-ToyBox-v089 ./test-configs/wc-02.sh
# basically, we call a specific test/example and send as argument the path of the program that we want it to run
sudo "$juleit" -n 1 "$the_test" "$program_path"
