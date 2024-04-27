#!/bin/bash

# Install amrl_msgs
# export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH
cd ~/robofleet_ecocar/robofleet_client/amrl_msgs
make

# Run flatbuffers code
cd ~/robofleet_ecocar/msg2fbs
make

# Install robofleet server dependencies
cd ~/robofleet_ecocar/robofleet_server
cp src/config.example.ts src/config.ts
yarn install && yarn build

# Install robofleet client dependencies
cd ~/robofleet_ecocar/robofleet_client
cp src/config.ecocar.hpp src/config.hpp
make

# Install robofleet_webviz
cd ~/robofleet_ecocar/robofleet_webviz
cp src/config.example.ts src/config.ts
export NODE_OPTIONS=--openssl-legacy-provider && yarn install && yarn build

cd ~/robofleet_ecocar

