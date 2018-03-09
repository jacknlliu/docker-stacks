FROM jupyter/tensorflow-notebook:latest

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

USER root

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y -q --no-install-recommends apt-transport-https aptitude locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116  \
    \
# update the repository and install ros kinetic
    && aptitude update -y -q && aptitude install -y -q -R ros-kinetic-ros-base python-rosinstall ninja-build python3-pip python3-setuptools\
    python3-defusedxml \
    ros-kinetic-gazebo-msgs ros-kinetic-rosbridge-library \
    ros-kinetic-rosbridge-server ros-kinetic-rosbridge-suite \
    \
# rosdep init
    && rosdep init

# install ros python3 support
RUN aptitude install -y -q -R python3-dev libyaml-0-2 libyaml-dev libyaml-cpp0.5 libyaml-cpp-dev && pip3 install --upgrade pip && pip3 install --no-cache-dir catkin-tools rospkg ws4py transforms3d trollius

# install dependecies for ros genmsg
RUN pip install empy

# install additional system packages and ros packages
# install additional build tool
RUN aptitude install -y -q -R build-essential gdb tmux \
    \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# install intel graphics driver
    && aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools

# install RoboWare
RUN aptitude install -y -q -R  wget python-pip pylint clang libxss1 libnss3 libnotify4 libxtst6 ~nlibgconf-2 \
    && export ROBOWAREVERSION="1.1.0-1514335284"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/Studio/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i roboware_amd64.deb \
    && apt-get install -y --no-install-recommends -f \
    && rm -f roboware_amd64.deb

# install essential tools, ssh sever, sudo
RUN aptitude update -y -q && aptitude install -y -q -R  bash-completion wget vim git iputils-ping iproute2 netcat terminator supervisor xauth openssh-server sudo pcmanfm

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# copy entrypoint file
RUN mkdir -p /opt/scripts/container/ && chmod -R a+rx /opt/scripts/
COPY ./scripts/*.sh /opt/scripts/container/
RUN chmod a+rwx /opt/scripts/container/*.sh

# copy supervisord.conf file
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add jupyter notebook tools
RUN pip3 install nbmerge nbdime

# setup ros env
USER jovyan
RUN HOME=/home/jovyan rosdep update  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/jovyan/.bashrc

# configure Qt
RUN mkdir -p /home/jovyan/.config/QtProject

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

# aptitude clean
RUN apt-get autoclean \
    && apt-get clean all \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Configure container startup
ENTRYPOINT ["tini", "-v", "--", "/opt/scripts/container/ros_entrypoint.sh"]
CMD ["start-notebook.sh"]

USER jovyan
WORKDIR /home/jovyan
