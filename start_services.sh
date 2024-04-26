#!/bin/sh

export ROBOFLEET_SERVER_PORT=8085

SAVED_PATH=$PWD

cd $SAVED_PATH/robofleet_client
ROS_NAMESPACE="leva" make run > $HOME_DIR/robofleet_client.log &
echo "Started client"

cd $SAVED_PATH/robofleet_server
yarn start > $HOME_DIR/robofleet_server.log &
echo "Started server"

cd $SAVED_PATH/robofleet_webviz
export NODE_OPTIONS=--openssl-legacy-provider
yarn start > $HOME_DIR/robofleet_webviz.log &
echo "Started webviz"
