# Description: Dockerfile for running robofleet
FROM ros:noetic-robot
RUN apt-get update && apt-get install -y \
  vim \
  qt5-default \
  libqt5websockets5-dev

# Install robofleet_server dependencies
RUN apt-get update && apt-get install -y curl python-is-python3 python3-pip
RUN apt-get install -y tmux
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

RUN npm install --global yarn

# compressed image based dependencies
RUN pip install opencv-python
RUN apt-get install -y ros-noetic-cv-bridge



