#!/bin/bash
cd /opt/ && git clone https://github.com/openai/roboschool.git
cd /opt/ && git clone https://github.com/openai/rllab.git

export ROBOSCHOOL_PATH=/opt/roboschool

aptitude install -y -q -R cmake ffmpeg \
    pkg-config qtbase5-dev libqt5opengl5-dev libassimp-dev libpython3.5-dev \
    libboost-python-dev libtinyxml-dev

cd /opt/ && git clone https://github.com/olegklimov/bullet3 -b roboschool_self_collision

mkdir bullet3/build && cd bullet3/build
cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 \
      -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install  \
      -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF  \
      -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF \
      -DBUILD_OPENGL3_DEMOS=OFF ..

make -j4
make install && cd /opt && pip3 install --no-cache-dir -e $ROBOSCHOOL_PATH

chmod a+rwx -R /opt/roboschool /opt/rllab
