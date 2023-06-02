#!/usr/bin/env bash

#if [[ $# -en 1 ]]
#then
#    echo "Usage: $0 <inputfile>"
#fi

input_file="../benchmark/test-inputs/align.sh"
wc_gnu="../pre-experiment/exe-GNU-v93/wc"
wc_toy="../pre-experiment/exe-ToyBox-v089/wc"
wc_busy="../pre-experiment/exe-BusyBox-1360-final/wc"

juleit="../src/jouleit.sh"

# If the input file does not exist, exit
if [ ! -e "$input_file" ]
then
    echo "Input file '$input_file' does not exist."
    exit 1
fi

# Otherwise, continue with the measurement of the energy consumption
sudo "$juleit" ./wc-02.sh


#sudo "$juleit" "$wc_gnu" -mlwc "$input_file"
#sudo "$juleit" "$wc_toy" -mlwc "$input_file"
#sudo "$juleit" "$wc_busy" -mlwc "$input_file"