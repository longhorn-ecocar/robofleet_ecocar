# Description: Dockerfile for running robofleet
FROM ros:noetic-robot

ENV ROS_PACKAGE_PATH=/home/robofleet_ecocar/robofleet_client:\
/home/robofleet_ecocar/robofleet_client/amrl_msgs:\
/home/datachecker:${ROS_PACKAGE_PATH} \
     ROS_IP=ubuntu.local \
     ROS_HOSTNAME=ubuntu.local \
     ROS_MASTER_URI=http://ubuntu.local:11311 \
     ROBOFLEET_SERVER_PORT=8080 \
     REACT_APP_ROBOFLEET_SERVER_PORT=8080

# install essentials
RUN apt-get update && apt-get install -y \
  vim \
  qt5-default \
  libqt5websockets5-dev \
  psmisc

# robofleet_server deps
RUN apt-get update && apt-get install -y \
  curl \
  python-is-python3 \
  python3-pip \
  tmux

# node & yarn
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - \
 && apt-get install -y nodejs \
 && npm install --global yarn

# Python & ROS image libs
RUN pip install opencv-python \
 && apt-get install -y ros-noetic-cv-bridge

# -----------------------------------------------------------------------------
# Add your environment vars so every interactive shell (e.g. in tmux) inherits them
# -----------------------------------------------------------------------------

WORKDIR /home/robofleet_ecocar