FROM jupyter/tensorflow-notebook:2bfbb7d17524

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

USER root

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y -q --no-install-recommends gnupg gnupg2 apt-transport-https aptitude locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116  \
    \
# update the repository and install ros kinetic
    && apt update -y -q && aptitude install -y -q -R ros-kinetic-ros-base python-rosinstall ninja-build python3-pip python-pip python3-setuptools python-setuptools \
    python3-defusedxml \
    ros-kinetic-gazebo-msgs ros-kinetic-rosbridge-library \
    ros-kinetic-rosbridge-server ros-kinetic-rosbridge-suite \
    ros-kinetic-tf2-web-republisher \
    ros-kinetic-tf2-relay ros-kinetic-tf2-geometry-msgs ros-kinetic-tf2-sensor-msgs \
    \
# rosdep init
    && rosdep init

# install ros python3 support
RUN apt install -y -q --no-install-recommends python3-dev libyaml-0-2 libyaml-dev libyaml-cpp0.5v5 libyaml-cpp-dev \
     && pip3 install --upgrade pip setuptools \
     && pip2 install --upgrade pip setuptools \
     && pip3 install --no-cache-dir catkin-tools rospkg ws4py transforms3d trollius \
     \
     # install roslibpy for ROS Bridge
    && pip3 install roslibpy; pip2 install roslibpy empy

# install dependecies for ros genmsg using pip2
RUN pip install empy

# install additional system packages and ros packages
# install additional build tool
RUN apt install -y -q --no-install-recommends build-essential gdb tmux \
    doxygen doxygen-gui \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# install intel graphics driver
    && aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools

# install RoboWare
RUN apt install -y -q --no-install-recommends wget python-pip pylint clang libxss1 libxtst6 \
    && export ROBOWAREVERSION="1.2.0-1524709819"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/Studio/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && apt install -y -q --no-install-recommends ./roboware_amd64.deb \
    && apt install -y -q --no-install-recommends -f \
    && rm -f roboware_amd64.deb

# install essential tools, ssh sever, sudo
RUN apt update -y -q && apt install -y -q --no-install-recommends  bash-completion \
    wget vim git iputils-ping iproute2 netcat terminator supervisor xauth openssh-server sudo pcmanfm \
    tree ranger curl ca-certificates openssl

# install system dependencies for urdf-viz
RUN apt install -y -q --no-install-recommends cmake xorg-dev libglu1-mesa-dev

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# copy entrypoint file
RUN mkdir -p /opt/scripts/container/ && chmod -R a+rx /opt/scripts/
COPY ./scripts/*.sh /opt/scripts/container/
RUN chmod a+rwx /opt/scripts/container/*.sh

# copy supervisord.conf file
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add jupyter notebook tools
RUN pip3 install nbmerge nbdime \
    && apt install -y -q --no-install-recommends python3-tk

RUN pip3 install pendulum pyquaternion tldr.py; pip2 install pandas scipy pendulum numpy pyquaternion

# setup ros env
USER jovyan
RUN HOME=/home/jovyan rosdep update  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/jovyan/.bashrc

# configure Qt
RUN mkdir -p /home/jovyan/.config/QtProject

# install urdf-rviz
RUN cd $HOME && curl https://sh.rustup.rs -sSf > rustup.sh && chmod a+x rustup.sh \
    && ./rustup.sh -y && rm -f ./rustup.sh \
    && echo "source $HOME/.cargo/env" >> $HOME/.bashrc \
    && /bin/bash -c "source $HOME/.cargo/env && cargo install -f urdf-viz"

USER root
COPY ./config/QtCreator.ini  /home/jovyan/.config/QtProject/
RUN chown -R jovyan:users  /home/jovyan/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/jovyan/.gazebo/models && chown -R jovyan:users /home/jovyan/.gazebo

# add sudo privilege for jovyan
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/notebook-ros

# add extra setup
RUN /opt/scripts/container/extra_setup.sh && rm -rf /opt/scripts/container/extra_setup.sh

# keep home privilege
RUN chown -R jovyan:users /home/jovyan/

# apt clean
RUN apt autoclean \
    && apt clean all \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Configure container startup
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/container/ros_entrypoint.sh"]
CMD ["start-notebook.sh"]

USER jovyan
WORKDIR /home/jovyan
