# Universal Robot Simulator

**NOTE:** This image just for research. All rights of the offline simulator applications belong to [Universal Robots A/S](https://www.universal-robots.com).


## Usage
```
docker run -it --security-opt label=disable --device /dev/dri --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -p 30001-30004:30001-30004  --name="ursim"   jacknlliu/ursim:5.3.1.64192 start-ursim.sh UR10
```

docker build . -t ursim:5.3.1.64192
docker run -it --rm  --security-opt label=disable -e DISPLAY=192.168.20.125:0.0 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --privileged -p 29999-30004:29999-30004 -p 502:502 --name="ursim"   ursim:5.3.1.64192 start-ursim.sh UR10
