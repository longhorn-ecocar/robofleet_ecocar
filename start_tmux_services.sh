#!/bin/bash

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

# Attach to the session
tmux attach -t $SESSION_NAME  
