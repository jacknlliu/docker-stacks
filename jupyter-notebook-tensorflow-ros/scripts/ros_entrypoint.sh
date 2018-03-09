#!/bin/bash
set -e

sudo /opt/scripts/container/containerinit.sh

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# start supervisor
sudo /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

if [[ -d "/data" ]]; then
  cd /data
fi

# start CMD
exec "$@"
