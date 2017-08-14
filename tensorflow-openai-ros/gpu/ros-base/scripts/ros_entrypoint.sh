#!/bin/bash
set -e

sudo /opt/scripts/container/containerinit.sh

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

export PYTHONPATH=$PYTHONPATH:/opt/tensorflow-models:/opt/tensorflow-models/slim

jupyter notebook -y --allow-root &

# start CMD
exec "$@"
