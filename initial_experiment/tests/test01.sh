#!/usr/bin/env bash

# Test case 1: Missing command-line arguments
echo "Running test case 1: Missing command-line arguments"
output=$(./test-configs/energy_measurement.sh)
expected_output="Usage: ./test-configs/energy_measurement.sh <programpath> <thetest>"

if [[ "$output" != "$expected_output" ]]
then
    echo "Test case 1 passed"
else
    echo "Test case 1 failed. Expected: $expected_output, Actual: $output"
fi
echo

# Test case 2: Missing required inputs
echo "Running test case 2: Missing required inputs"
output=$(./test-configs/energy_measurement.sh "./inputs/exe-GNU-v93")
expected_output="Error: Missing required inputs. Check the 'Usage'."

if [[ "$output" != "$expected_output" ]]; then
    echo "Test case 2 passed"
else
    echo "Test case 2 failed. Expected: $expected_output, Actual: $output"
fi
echo

# Test case 3: Valid command-line arguments
echo "Running test case 3: Valid command-line arguments"
output=$(./test-configs/energy_measurement.sh "../inputs/exe-GNU-v93" "./test-configs/wc-02.sh")

