#!/bin/bash
sudo docker run --net=host -it \
    -v `pwd`:/home/robofleet_ecocar \
    --shm-size 16g robofleet_ecocar \