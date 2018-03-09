#!/bin/bash
set -e

sudo /opt/scripts/container/containerinit.sh

# switch jupyter notebook local data to /data
if [[ -d "/data" ]]; then
  cd /data
fi

jupyter notebook -y --allow-root &

cd /home/ros/

# start CMD
exec "$@"
