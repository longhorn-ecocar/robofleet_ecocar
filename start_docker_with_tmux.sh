#!/bin/bash

# Run the Docker container and wait for the process to finish
docker run --net=host -it \
    -v $(pwd):/home/robofleet_ecocar \
    --shm-size 16g \
    -w /home/robofleet_ecocar \
    robofleet_ecocar \
    bash -c "cd /home/robofleet_ecocar"

# Wait for the Docker process to finish
wait $!

# this is designed to only work for local testing (localhost:3000)

# Name of the tmux session
SESSION_NAME="hmio_display"

# Check if the session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
  # Create a new tmux session
  tmux new-session -d -s $SESSION_NAME -n "client"

  # Create additional named windows
  tmux new-window -t $SESSION_NAME:1 -n "server"
  tmux new-window -t $SESSION_NAME:2 -n "webviz"
  tmux new-window -t $SESSION_NAME:3 -n "roscore"
  tmux new-window -t $SESSION_NAME:4 -n "python_dummy"

  # Optional: Run commands in each window
  tmux send-keys -t $SESSION_NAME:0 'cd /home/robofleet_ecocar/robofleet_client && export ROBOFLEET_SERVER_PORT=8080 && ROS_NAMESPACE="leva" make run' C-m
  tmux send-keys -t $SESSION_NAME:1 'cd /home/robofleet_ecocar/robofleet_server && yarn start' C-m
  tmux send-keys -t $SESSION_NAME:2 'cd /home/robofleet_ecocar/robofleet_webviz && export NODE_OPTIONS=--openssl-legacy-provider && yarn start' C-m
  tmux send-keys -t $SESSION_NAME:3 'roscore' C-m
  tmux send-keys -t $SESSION_NAME:4 'cd /home/robofleet_ecocar/robofleet_client/scripts && export ROS_PACKAGE_PATH=/home/robofleet_ecocar/robofleet_client/amrl_msgs && python3 test_publisher.py' C-m
fi