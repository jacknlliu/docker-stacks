FROM jacknlliu/tensorflow-openai-ros:origin-py3

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

USER root

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -f -y --no-install-recommends && apt-get install -y -q --no-install-recommends apt-transport-https aptitude locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# define tini version
ENV TINI_VERSION v0.17.0

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116  \
    \
# update the repository and install ros kinetic
    && apt update -y -q && apt install -y -q --no-install-recommends ros-kinetic-ros-base python-rosinstall ninja-build python3-pip python-pip python3-setuptools python-setuptools \
    python3-defusedxml python3-dev \
    ros-kinetic-gazebo-msgs ros-kinetic-rosbridge-library \
    ros-kinetic-rosbridge-server ros-kinetic-rosbridge-suite \
    ros-kinetic-tf2-web-republisher \
    ros-kinetic-tf2-relay ros-kinetic-tf2-geometry-msgs ros-kinetic-tf2-sensor-msgs

# install ros python3 support
RUN pip3 install --upgrade pip setuptools virtualenv && pip3 install --no-cache-dir catkin-tools rospkg ws4py transforms3d trollius \
     \
     # install roslibpy for ROS Bridge
    && pip3 install roslibpy; pip2 install --upgrade pip setuptools; pip2 install roslibpy empy

# install dependecies for ros genmsg using pip2
RUN pip install empy

# install additional system packages and ros packages
# install additional build tool
RUN apt install -y -q --no-install-recommends build-essential gdb tmux \
    doxygen doxygen-gui \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && apt install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# install intel graphics driver
    && apt install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && apt install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools

# install RoboWare
RUN apt install -y -q --no-install-recommends wget python-pip pylint clang libxss1 libxtst6 \
    && export ROBOWAREVERSION="1.2.0-1524709819"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/Studio/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && apt install -y -q --no-install-recommends ./roboware_amd64.deb \
    && apt install -y -q --no-install-recommends -f \
    && rm -f roboware_amd64.deb

# install essential tools, ssh sever, sudo
RUN apt update -y -q && apt install -y -q --no-install-recommends  bash-completion \
    wget vim git iputils-ping iproute2 netcat terminator xauth openssh-server sudo pcmanfm \
    tree ranger curl ca-certificates openssl

# install ros related components
RUN apt install -y -q --no-install-recommends ros-kinetic-controller-manager \
    ros-kinetic-tf  ros-kinetic-urdf \
    ros-kinetic-ros-controllers \
    ros-kinetic-hardware-interface \
    ros-kinetic-orocos-kdl \
    ros-kinetic-orocos-kinematics-dynamics \
    ros-kinetic-pid  \
    \
    # install orocos rtt components
    && apt install -y -q --no-install-recommends ros-kinetic-rtt ros-kinetic-rtt-* \
    \
# install Barret_Hand related components
    && apt install -y -q --no-install-recommends libignition-math2-dev \
    \
# install kinematics module
    && apt install -y -q --no-install-recommends ros-kinetic-calibration-estimation ros-kinetic-kdl-parser-py  \
    \
# install fast inverse kinematics module
    && apt install -y -q --no-install-recommends  ros-kinetic-trac-ik-lib

# install system dependencies for urdf-viz
# RUN apt install -y -q --no-install-recommends cmake xorg-dev libglu1-mesa-dev

# install machine learning packages
RUN mkdir -p /opt/scripts/container/ && chmod -R a+rx /opt/scripts/ \
    && cd /opt/scripts/container/ && pip3 install git+https://github.com/AlexanderFabisch/gmr.git

# copy entrypoint file
COPY ./scripts/*.sh ./config/requirements*.txt  /opt/scripts/container/

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

RUN chmod a+rwx /opt/scripts/container/ros_entrypoint.sh /opt/scripts/container/containerinit.sh \
    /opt/scripts/container/tensorflow-models.sh && sync && /opt/scripts/container/tensorflow-models.sh

# add jupyter notebook tools
RUN pip3 install nbmerge nbdime \
    && apt install -y -q --no-install-recommends python3-tk

RUN pip3 install pandas scipy pendulum pyquaternion tldr.py; pip2 install pandas scipy pendulum numpy pyquaternion

# set user ros and sudo
ENV DOCKER_USER ros
RUN adduser --gecos "ROS User" --home /home/$DOCKER_USER --disabled-password $DOCKER_USER && \
    usermod -a -G dialout $DOCKER_USER && \
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# setup ros env
USER $DOCKER_USER
RUN sudo rosdep init && rosdep update  \
    && mkdir -p /home/$DOCKER_USER/.local/lib/python2.7/site-packages \
    && echo "/opt/ros/$ROS_DISTRO/lib/python2.7/dist-packages" >> /home/$DOCKER_USER/.local/lib/python2.7/site-packages/ros-dev.pth \
    && mkdir -p /home/$DOCKER_USER/.local/lib/python3.5/site-packages \
    && echo -e "/opt/tensorflow-models/research\n/opt/tensorflow-models/research/slim" >> /home/$DOCKER_USER/.local/lib/python3.5/site-packages/tensorflow-models.pth


# install openai/baselines, roboschool, gym related python packages
RUN sudo chmod +x /opt/scripts/container/dart_drl.sh /opt/scripts/container/requirements*.txt && \
    sudo /opt/scripts/container/dart_drl.sh

# configure Qt
RUN mkdir -p /home/$DOCKER_USER/.config/QtProject

# install urdf-rviz
# RUN cd $HOME && curl https://sh.rustup.rs -sSf > rustup.sh && chmod a+x rustup.sh \
#     && ./rustup.sh -y && rm -f ./rustup.sh \
#     && echo "source $HOME/.cargo/env" >> $HOME/.bashrc \
#     && /bin/bash -c "source $HOME/.cargo/env && cargo install -f urdf-viz"

USER root

# apt clean and installation scripts clean
RUN apt autoclean \
    && apt clean all \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /opt/scripts/container/tensorflow-models.sh /opt/scripts/container/dart_drl.sh

COPY ./config/QtCreator.ini  /home/$DOCKER_USER/.config/QtProject/
RUN chown -R $DOCKER_USER:users  /home/$DOCKER_USER/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/$DOCKER_USER/.gazebo/models && chown -R $DOCKER_USER:users /home/$DOCKER_USER/.gazebo \
    && mkdir /home/$DOCKER_USER/.jupyter \
    && cp -f /root/.jupyter/jupyter_notebook_config.py /home/$DOCKER_USER/.jupyter/ \
    && chown -R $DOCKER_USER:users /home/$DOCKER_USER/.jupyter \
    && chmod 755 /home/$DOCKER_USER/.jupyter/jupyter_notebook_config.py

# Add Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Configure container startup, '-v' is needed, please see [using-tini](https://github.com/krallin/tini#using-tini)
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/container/ros_entrypoint.sh"]
CMD ["bash"]

USER $DOCKER_USER
WORKDIR /home/$DOCKER_USER
