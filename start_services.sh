#!/bin/sh

cd $1

source /opt/ros/noetic/setup.bash

export ROS_PACKAGE_PATH=/home/autera-admin/robofleet_ecocar/robofleet_client:$ROS_PACKAGE_PATH
export ROS_PACKAGE_PATH=/home/autera-admin/infrastructure/ros1_utils/amrl_msgs:$ROS_PACKAGE_PATH
export ROS_PACKAGE_PATH=/home/autera-admin/datachecker:$ROS_PACKAGE_PATH

export ROS_IP=192.168.131.1
export ROS_HOSTNAME=192.168.131.1
export ROS_MASTER_URI=http://$ROS_IP:11311

export ROBOFLEET_SERVER_PORT=8084
export REACT_APP_ROBOFLEET_SERVER_PORT=$ROBOFLEET_SERVER_PORT

SAVED_PATH=$PWD

# start robofleet client
cd $SAVED_PATH/robofleet_client
ROS_NAMESPACE="leva" make run &> /home/autera-admin/infrastructure/robofleet_ecocar/robofleet_client.log &
echo "Started client"

# start robofleet server
cd $SAVED_PATH/robofleet_server
yarn start &> /home/autera-admin/infrastructure/robofleet_ecocar/robofleet_server.log &
echo "Started server"

# start robofleet webviz
cd $SAVED_PATH/robofleet_webviz
export NODE_OPTIONS=--openssl-legacy-provider
yarn start &> /home/autera-admin/infrastructure/robofleet_ecocar/robofleet_webviz.log
# yarn start &
echo "Started webviz"
