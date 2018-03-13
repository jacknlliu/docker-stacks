#!/bin/bash
cd /opt/ && git clone https://github.com/openai/roboschool.git
cd /opt/ && git clone https://github.com/openai/rllab.git

# start install openai/roboschool
export ROBOSCHOOL_PATH=/opt/roboschool

aptitude install -y -q -R cmake ffmpeg \
    pkg-config qtbase5-dev libqt5opengl5-dev libassimp-dev \
    libboost-python-dev libtinyxml-dev

# we try to replace libpython3.5-dev by libpython3-dev
aptitude install -y -q -R libpython3-dev

# for avoid opengl errors [issue #15](https://github.com/openai/roboschool/issues/15#issuecomment-308620049)
pip3 install -U --no-cache-dir pyopengl

cd /opt/ && git clone https://github.com/olegklimov/bullet3 -b roboschool_self_collision

mkdir bullet3/build && cd bullet3/build
cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 \
      -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install  \
      -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF  \
      -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF \
      -DBUILD_OPENGL3_DEMOS=OFF ..

make -j4
make install && cd /opt && pip3 install --no-cache-dir -e $ROBOSCHOOL_PATH

chmod a+rwx -R /opt/roboschool

# start install openai/rllab

# ========== Special Deps ==========
aptitude install -y -q -R git make cmake unzip
pip3 install --no-cache-dir awscli
# ALE requires zlib
aptitude install -y -q -R zlib1g-dev
# MUJOCO requires graphics stuff (Why?)
apt-get -y build-dep glfw
aptitude install -y -q -R libxrandr2 libxinerama-dev libxi6 libxcursor-dev
# copied from requirements.txt
#  pip install imageio tabulate nose
aptitude install -y -q -R vim ack-grep
pip3 install --upgrade pip
# usual pip install pygame will fail
apt-get build-dep -y python-pygame
pip3 install --no-cache-dir Pillow

# ========== OpenAI Gym ==========
aptitude install -y -q -R libgtk2.0-0
pip3 install gym
#  apt-get -y install ffmpeg
aptitude install -y -q -R libav-tools
# set alias in /home/ros/.bashrc
# alias ffmpeg="avconv"

# install rllab dependencies
pip3 install --no-cache-dir -r /opt/scripts/container/requirements.txt

# fix pytorch not spport for this python
pip3 install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl
pip3 install --no-cache-dir torchvision

chmod a+rwx -R  /opt/rllab

# install mujoco-py before baselines
aptitude install -y -q -R libosmesa6-dev

mkdir -p ~/.mujoco \
    && wget https://www.roboti.us/download/mjpro150_linux.zip -O mujoco.zip \
    && unzip mujoco.zip -d ~/.mujoco \
    && rm mujoco.zip

export LD_LIBRARY_PATH=~/.mujoco/mjpro150/bin:$LD_LIBRARY_PATH

echo 'export LD_LIBRARY_PATH=~/.mujoco/mjpro150/bin:$LD_LIBRARY_PATH' >> ~/.bashrc

# install baselines with tensorflow-gpu
cd /opt/ &&  git clone https://github.com/openai/baselines.git
cd baselines && python3 setup.py sdist && pip3 install dist/*.tar.gz
cd / && rm -rf /opt/baselines
