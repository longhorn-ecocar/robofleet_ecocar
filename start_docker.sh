#!/bin/bash
docker run --net=host -it \
    -e "HOME=/home" \
    -v `pwd`:/home/robofleet_ecocar \
    --shm-size 16g robofleet_ecocar \
