#!/bin/sh

source /opt/ros/noetic/setup.bash

export ROS_PACKAGE_PATH=/home/autera-admin/robofleet_ecocar/robofleet_client:$ROS_PACKAGE_PATH
export ROS_PACKAGE_PATH=/home/autera-admin/infrastructure/ros1_utils/amrl_msgs:$ROS_PACKAGE_PATH
export ROS_PACKAGE_PATH=/home/autera-admin/datachecker:$ROS_PACKAGE_PATH

export ROS_IP=192.168.131.1
export ROS_HOSTNAME=192.168.131.1
export ROS_MASTER_URI=http://$ROS_IP:11311

cd /home/autera-admin/robofleet_ecocar/robofleet_client/scripts
python test_publisher.py
