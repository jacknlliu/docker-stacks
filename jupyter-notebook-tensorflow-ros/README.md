# jupyter-notebook-tensorflow-ros

This image is forked from [Jupyter Notebook Scientific Python Stack + Tensorflow](https://github.com/jupyter/docker-stacks/tree/master/tensorflow-notebook). And this image integrate with [ros base](http://wiki.ros.org/kinetic/Installation/Ubuntu).


## Usage
```
docker run -it --security-opt label=disable \
    --device /dev/dri --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -p 8888:8888 \
    --name "jupyter-tensorflow" \
    jacknlliu/jupyter-tensorflow-ros-base:kinetic start-notebook.sh --NotebookApp.token=''
```
More start command similar with upstream image, please see [here](https://github.com/jupyter/docker-stacks/tree/master/tensorflow-notebook).
