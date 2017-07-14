FROM jacknlliu/ubuntu-init:14.04.5

MAINTAINER Jack Liu <jacknlliu@gmail.com>

# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV ROS_DISTRO indigo

# setup locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# install tiago dependencies
RUN  apt-get update -y && apt-get upgrade -y -q --no-install-recommends -o Dpkg::Options::="--force-confold" \
    && apt-get install -y -q --no-install-recommends software-properties-common \
    && add-apt-repository --yes ppa:xqms/opencv-nonfree  \
    && apt-get update -y -q \
    && apt-get install -y -q --no-install-recommends libopencv-nonfree-dev

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
    \
# setup keys
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    \
# update the repository and install ros packages
    && apt-get update -y \
    && apt-get install -y -q --no-install-recommends apt-utils apt-transport-https aptitude \
    && aptitude install -y -q -R ros-indigo-desktop-full python-rosinstall ninja-build \
    && rosdep init

# install additional system packages and ros packages
# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-latest.list \
    && curl http://packages.osrfoundation.org/gazebo.key |apt-key add - \
    && aptitude update -y -q \
    && aptitude upgrade -y -q -R gazebo2

# install essential tools
RUN aptitude install -y -q -R  bash-completion wget vim git iputils-ping iproute2 netcat tmux terminator supervisor xauth openssh-server sudo pcmanfm \
    \
# install additional build tool
    && aptitude install -y -q -R build-essential gdb \
    \
# install IDE essential packages
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# setup ssh
    && mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# install intel graphics driver
RUN aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils \
# we should fix AMD graphics driver with image driver extension not found in ubuntu 14.04.2, refrence: https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_14.04_LTS_-_Trusty_Tahr
    \
    && aptitude install -y -q -R linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial


# install ros related components
RUN aptitude install -y -q -R ros-indigo-moveit-full \
    ros-indigo-gazebo-ros-control \
    ros-indigo-ros-controllers \
    ros-indigo-controller-manager \
    ros-indigo-rqt-controller-manager \
    ros-indigo-ur-description \
    ros-indigo-camera-calibration \
    ros-indigo-camera-calibration-parsers \
    ros-indigo-camera-info-manager \
    ros-indigo-twist-mux ros-indigo-joy ros-indigo-joy-teleop \
    ros-indigo-teleop-tools ros-indigo-control-toolbox ros-indigo-sound-play \
    ros-indigo-navigation ros-indigo-eband-local-planner \
    ros-indigo-depthimage-to-laserscan  ros-indigo-openslam-gmapping \
    ros-indigo-gmapping ros-indigo-moveit-commander \
    ros-indigo-geometry-experimental \
    \
# install orocos rtt components
    && aptitude install -y -q -R ros-indigo-orocos-kdl ros-indigo-rtt ~nros-indigo-rtt-*


# install RoboWare
RUN aptitude install -y -q -R  python-pip pylint clang libnss3 libnotify4  libxtst6 ~nlibgconf-2 \
    && export ROBOWAREVERSION="0.6.0-1495845302"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i roboware_amd64.deb \
    && rm -f roboware_amd64.deb

# copy entrypoint file
COPY ./scripts/ros_entrypoint.sh /
COPY ./scripts/containerinit.sh /etc/my_init.d/
RUN chmod +x /ros_entrypoint.sh && chmod +x /etc/my_init.d/containerinit.sh


# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros && \
    usermod -a -G dialout ros && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, but the HOME is still /, not /home/ros
USER ros

# setup ros env
RUN HOME=/home/ros rosdep update  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

# configure Qt
RUN mkdir -p /home/ros/.config/QtProject

USER root

COPY ./config/QtCreator.ini  /home/ros/.config/QtProject/
RUN chown -R ros:ros  /home/ros/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/ros/.gazebo/models && chown -R ros:ros /home/ros/.gazebo

# share this volume with other containers from this image
VOLUME ["/home/ros/.gazebo/models"]

# install tiago sdk
RUN mkdir -p /home/ros/Workspace/tiago_public_ws/src \
    && chmod -R a+rwx /home/ros/Workspace/tiago_public_ws \
    && cd /home/ros/Workspace/tiago_public_ws \
    && wget -O tiago_public.rosinstall https://raw.githubusercontent.com/pal-robotics/tiago_tutorials/master/tiago_public.rosinstall \
    && yes | rosinstall src /opt/ros/indigo tiago_public.rosinstall \
    && rosdep update \
    && yes | rosdep install --from-paths src --ignore-src --rosdistro indigo --skip-keys="opencv2 opencv2-nonfree pal_laser_filters speed_limit sensor_to_cloud"  \
    && chown -R ros:ros /home/ros/Workspace

# aptitude clean
RUN aptitude clean -y -q \
    && aptitude -o Aptitude::Delete-Unused=1 install -y -q \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# cd /home/ros default
WORKDIR /home/ros

# must run /sbin/my_init with root user
ENTRYPOINT ["/sbin/my_init", "--quiet", "--", "setuser", "ros", "/ros_entrypoint.sh"]
CMD ["bash"]
