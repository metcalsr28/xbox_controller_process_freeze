#!/bin/bash

# Check if a process ID was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 PROCESS_ID"
    exit 1
fi

# Assign the first argument to PROCESS_ID
PROCESS_ID=$1

# Replace with the correct event number for your controller
CONTROLLER_EVENT="/dev/input/event16"

# Initialize the state of the process (0 for running, 1 for stopped)
PROCESS_STATE=0

# Function to check for Xbox button press
check_xbox_button() {
    # Replace BTN_MODE with the specific button code for the Xbox button
    grep -q "(BTN_MODE), value 1" 
}

# Monitor the controller input
stdbuf -oL -eL evtest "$CONTROLLER_EVENT" | while read line; do
    if check_xbox_button <<< "$line"; then
        if [ $PROCESS_STATE -eq 0 ]; then
            echo "Xbox button pressed, pausing process $PROCESS_ID"
            kill -Stop $PROCESS_ID
            PROCESS_STATE=1
        else
            echo "Xbox button pressed, resuming process $PROCESS_ID"
            kill -Cont $PROCESS_ID
            PROCESS_STATE=0
        fi
    fi
done

echo "Script started. Listening for Xbox button press..."
