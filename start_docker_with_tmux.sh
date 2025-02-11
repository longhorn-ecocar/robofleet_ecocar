#!/bin/bash

docker run --net=host -it \
    -v $(pwd):/home/robofleet_ecocar \
    --shm-size 16g \
    -w /home/robofleet_ecocar \
    robofleet_ecocar \
    bash -c "./start_tmux_services.sh"
