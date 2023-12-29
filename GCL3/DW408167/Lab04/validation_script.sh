#!/bin/bash

# Get the IP address of the container
ip=$(docker inspect -f {{ .NetworkSettings.IPAddress }} nest-deploy-container)

# Make a request to the specified URL
response=$(curl -s "$ip:3000/fib/1")

echo "Response: $response"

# Define the expected response
expected_response='[0,1]'

# Compare the actual response with the expected response
if [ "$response" == "$expected_response" ]; then
    echo "Success: The response is as expected."
else
    echo "Error: The response is not as expected." >&2
    exit 1
fi