#!/bin/bash
set -e

sudo /opt/scripts/container/containerinit.sh

jupyter notebook -y --allow-root &

# start CMD
exec "$@"
