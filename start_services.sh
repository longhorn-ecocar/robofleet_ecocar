#!/bin/sh

export ROBOFLEET_SERVER_PORT=8085

SAVED_PATH=$PWD

cd $SAVED_PATH/robofleet_client
ROS_NAMESPACE="leva" make run &
echo "Started client"

cd $SAVED_PATH/robofleet_server
yarn start &
echo "Started server"

cd $SAVED_PATH/robofleet_webviz
export NODE_OPTIONS=--openssl-legacy-provider
yarn start
echo "Started webviz"