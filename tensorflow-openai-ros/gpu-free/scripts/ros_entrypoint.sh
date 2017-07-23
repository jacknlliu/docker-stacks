#!/bin/bash
set -e

sudo /containerinit.sh

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

jupyter notebook -y --allow-root &

# start CMD
exec "$@"
