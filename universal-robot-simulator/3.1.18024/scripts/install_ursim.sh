#! /bin/bash
set -e \
    && export UR_DOWNLOAD_SITE="https://s3-eu-west-1.amazonaws.com/ur-support-site/16634/ursim-3.1.18024.tar.gz" \
    && export URSIMVERSION="3.1.18024"  \
    && export INSTALL_DIR=$1  \
    && export URSIM_USER=$2  \
    && echo "INSTALL_DIR: $INSTALL_DIR \n URSIM_USER: $URSIM_USER" \
    \
    && echo "install ursim" > /dev/null \
    && cd $INSTALL_DIR && wget -q -O ursim.tar.gz ${UR_DOWNLOAD_SITE} && tar -xvzf ursim.tar.gz && mv ursim-3.1 ursimpkg && cd ursimpkg \
    \
    && echo "delete 36-37 lines for no xterm exit" > /dev/null \
    && sed -i '6,10c  echo \"just ignore terminal warning\" ' ./install.sh \
    && sed -i 's/pkexec bash -c/bash -c/g' ./install.sh \
    && sed -i 's/apt-get -y install/apt-get -y install -q --no-install-recommends/g' ./install.sh \
    && sed -i '27,40d' ./install.sh  \
    && sed -i '29d' ./install.sh  \
    && echo "echo \" installation done! \""  >> ./install.sh \
    && ./install.sh \
    && cd .. && rm -f ./ursim.tar.gz \
    && chown -R $URSIM_USER:$URSIM_USER ursimpkg \
    && chmod a+rx  ursimpkg/URControl
