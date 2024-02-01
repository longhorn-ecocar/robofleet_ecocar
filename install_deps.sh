#!/bin/bash

# Install robofleet server dependencies
cd /home/robofleet_ecocar/robofleet_server
yarn install && yarn build

# Install amrl_msgs
cd /home/robofleet_ecocar/robofleet_client/amrl_msgs
echo ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH >> ~/.bashrc
source ~/.bashrc
make

# Install robofleet client dependencies
cd /home/robofleet_ecocar/robofleet_client
cp src/config.example.hpp src/config.hpp
make


# Install robofleet_webviz
cd /home/robofleet_ecocar/robofleet_webviz
cp src/config.example.ts src/config.ts

# TODO: figure out why this is not sourcing properly
export NODE_OPTIONS=--openssl-legacy-provider && yarn install && yarn build

