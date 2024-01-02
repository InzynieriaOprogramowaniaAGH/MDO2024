# Deploy application
minikube kubectl -- apply -f deployment-01.yaml

# Start timer
start_time=$(date +%s)

# Set a timeout for 60 seconds
timeout=60
end_time=$(($start_time + $timeout))

# Loop to check the rollout status
while true; do
    # Check if current time is greater than end time
    if [ $(date +%s) -gt $end_time ]; then
        echo "Rollout did not complete within 60 seconds."
        exit 1
    fi

    # Check the rollout status
    if minikube kubectl -- rollout status deployment/nest-app --timeout=1s; then
        echo "Rollout completed successfully within 60 seconds."
        exit 0
    fi

    # Wait for a short period before checking again
    sleep 1
done