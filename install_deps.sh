#!/bin/bash

echo ROS_PACKAGE_PATH=`pwd`/robofleet_client:$ROS_PACKAGE_PATH >> ~/.bashrc
source ~/.bashrc

# Install amrl_msgs
export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH
cd /home/robofleet_ecocar/robofleet_client/amrl_msgs
make

# Run flatbuffers code
cd /home/robofleet_ecocar/msg2fbs
make

# Install robofleet server dependencies
cd /home/robofleet_ecocar/robofleet_server
cp src/config.example.ts src/config.ts
yarn install && yarn build

# Install robofleet client dependencies
cd /home/robofleet_ecocar/robofleet_client
cp src/config.ecocar.hpp src/config.hpp
make

# Install robofleet_webviz
cd /home/robofleet_ecocar/robofleet_webviz
cp src/config.example.ts src/config.ts

# TODO: figure out why this is not sourcing properly
export NODE_OPTIONS=--openssl-legacy-provider && yarn install && yarn build

