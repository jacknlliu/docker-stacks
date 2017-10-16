# tiago-ros

## Usage
```
docker run -it  --privileged    \
 --security-opt label=disable      \
 --security-opt seccomp=unconfined   \
 --env="DISPLAY" --env QT_X11_NO_MITSHM=1  \
 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
 --volume="/path/to/gazebo_models:/home/ros/.gazebo/models:rw" \
 --name="tiago-ros" \
 jacknlliu/tiago-ros:indigo terminator
```
