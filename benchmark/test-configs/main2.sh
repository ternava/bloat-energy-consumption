#!/usr/bin/env bash

# Calls the script for measuring the nergy consumption of a given program
# then saves the results in a .csv file

em="./test-configs/energy_measurement.sh"

{ echo "wc_gnu"; "$em"; } > output.csv