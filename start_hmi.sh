#!/bin/bash
set -e

# -------- USAGE & ARG PARSING --------
DEBUG_PUBLISHER=0
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --debug) DEBUG_PUBLISHER=1; shift ;;
    *) echo "Unknown option: $1"; echo "Usage: $0 [--debug]"; exit 1 ;;
  esac
done

# -------- CONFIGURATION --------
IMAGE="robofleet_ecocar"
CONTAINER_NAME="robofleet_ecocar_ctn"
HOST_WORKDIR="/home/warthog/robofleet_ecocar"
CTN_WORKDIR="/home/robofleet_ecocar"
SESSION="hmio_display"
# -------------------------------------

# 1) Start (or reuse) the container
if ! docker ps -q -f name="^/${CONTAINER_NAME}$" | grep -q .; then
  # Remove any stopped container of the same name
  if docker ps -aq -f name="^/${CONTAINER_NAME}$" | grep -q .; then
    docker rm "${CONTAINER_NAME}"
  fi

  docker run -d \
    --name "${CONTAINER_NAME}" \
    --net=host \
    -v "${HOST_WORKDIR}:${CTN_WORKDIR}" \
    --shm-size 16g \
    -w "${CTN_WORKDIR}" \
    "${IMAGE}" \
    sleep infinity

  echo "▶ Started container ${CONTAINER_NAME}"
else
  echo "▶ Container ${CONTAINER_NAME} already running"
fi

# 2) Inside the container: env setup, kill port, tmux session (+ optional dummy)
docker exec "${CONTAINER_NAME}" bash -lc "
  # --- Source ROS & set environment ---
  source /opt/ros/noetic/setup.bash
  export ROS_PACKAGE_PATH=${CTN_WORKDIR}/robofleet_client:${CTN_WORKDIR}/infrastructure/ros1_utils/amrl_msgs:${CTN_WORKDIR}/datachecker:\$ROS_PACKAGE_PATH
  export ROS_IP=ubuntu
  export ROS_HOSTNAME=\$ROS_IP
  export ROS_MASTER_URI=http://\$ROS_IP:11311
  export ROBOFLEET_SERVER_PORT=8080
  export REACT_APP_ROBOFLEET_SERVER_PORT=\$ROBOFLEET_SERVER_PORT

  # Kill any existing process on that port
  fuser -k \$ROBOFLEET_SERVER_PORT/tcp && echo \"Killed processes on port \$ROBOFLEET_SERVER_PORT\"

  # --- Create tmux session & windows if needed ---
  if ! tmux has-session -t ${SESSION} 2>/dev/null; then
    tmux new-session    -d -s ${SESSION} -n client
    tmux new-window     -t ${SESSION}:1 -n server
    tmux new-window     -t ${SESSION}:2 -n webviz
    tmux new-window     -t ${SESSION}:3 -n roscore

    # Conditionally create the python_dummy window
    if [ ${DEBUG_PUBLISHER} -eq 1 ]; then
      tmux new-window -t ${SESSION}:4 -n python_dummy
    fi

    # --- Dispatch commands into each pane ---
    tmux send-keys -t ${SESSION}:0 \"cd ${CTN_WORKDIR}/robofleet_client && export ROBOFLEET_SERVER_PORT=8080 && ROS_NAMESPACE=leva make run\" C-m
    tmux send-keys -t ${SESSION}:1 \"cd ${CTN_WORKDIR}/robofleet_server && yarn start\" C-m
    tmux send-keys -t ${SESSION}:2 \"cd ${CTN_WORKDIR}/robofleet_webviz && export NODE_OPTIONS=--openssl-legacy-provider && yarn start\" C-m
    tmux send-keys -t ${SESSION}:3 \"roscore\" C-m

    # If debug enabled, wire up the dummy publisher
    if [ ${DEBUG_PUBLISHER} -eq 1 ]; then
      tmux send-keys -t ${SESSION}:4 \"cd ${CTN_WORKDIR}/robofleet_client/scripts && export ROS_PACKAGE_PATH=${CTN_WORKDIR}/robofleet_client/amrl_msgs && python3 test_publisher.py\" C-m
    fi

    echo \"✔ Tmux session '${SESSION}' created inside container\"
  else
    echo \"ℹ Tmux session '${SESSION}' already exists\"
  fi
"

echo
echo "✅ Setup complete!"
echo "To attach: docker exec -it ${CONTAINER_NAME} tmux attach -t ${SESSION}"
echo "Run with dummy publisher: $0 --debug"
