#!/bin/bash
set -e

sudo /opt/scripts/container/containerinit.sh

# setup ros environment
# FIXME: we should't set the ros path environment to here, because the ROS bad convention for python2 and python3
# source "/opt/ros/$ROS_DISTRO/setup.bash"

# start supervisor
sudo /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

if [[ -d "/data" ]]; then
  cd /data
fi

# start CMD
exec "$@"
