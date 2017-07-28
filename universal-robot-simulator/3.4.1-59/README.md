# Universal Robot Simulator

**NOTE:** This image just for research. All rights of the offline simulator applications belong to [Universal Robots A/S](https://www.universal-robots.com).


## Usage
```
docker run -it --security-opt label=disable \
       --device /dev/dri --env="DISPLAY" \
       --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
       -p 30001-30004:30001-30004  \
       --name="ursim"   jacknlliu/ursim:3.4.1-59 start-ursim.sh UR5
```
