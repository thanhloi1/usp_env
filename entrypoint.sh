#!/bin/bash

cd /host_dir

# Run mosquitto broker
cp mosquitto.conf /etc/mosquitto/mosquitto.conf
mosquitto -c /etc/mosquitto/mosquitto.conf &

#Run obuspc controller
chmod +x ./restart_obuspc_controller.sh
./restart_obuspc_controller.sh

/bin/bash
