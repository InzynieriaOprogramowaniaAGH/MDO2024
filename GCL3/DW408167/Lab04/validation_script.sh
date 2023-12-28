#!/bin/bash

# Make a request to the specified URL
response=$(curl -s localhost:3000/fib/1)

# Define the expected response
expected_response='[0,1]'

# Compare the actual response with the expected response
if [ "$response" == "$expected_response" ]; then
    echo "Success: The response is as expected."
else
    echo "Error: The response is not as expected." >&2
    exit 1
fi