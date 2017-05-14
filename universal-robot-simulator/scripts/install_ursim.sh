#! /bin/bash
set -e \
    && export UR_DOWNLOAD_SITE="https://s3-eu-west-1.amazonaws.com/ur-support-site/28546/ursim-3.4.1-59.tar.gz" \
    && export URSIMVERSION="3.4.1-59"  \
    && export INSTALL_DIR=$1  \
    && export URSIM_USER=$2  \
    && echo "INSTALL_DIR: $INSTALL_DIR \n URSIM_USER: $URSIM_USER" \
    \
    && echo "install ursim" > /dev/null \
    && cd $INSTALL_DIR && wget -O ursim.tar.gz ${UR_DOWNLOAD_SITE} && tar -xvzf ursim.tar.gz && cd ursim-${URSIMVERSION} \
    \
    && echo "delete 36-37 lines for no xterm exit" > /dev/null \
    && sed -i '36,37c \\\t echo \"just ignore xterm warning\" ' ./install.sh \
    && sed -i 's/pkexec bash -c/bash -c/g' ./install.sh \
    && sed -i 's/apt-get -y install/aptitude install -y -q -R/g' ./install.sh \
    && ./install.sh \
    && cd .. && rm -f ./ursim.tar.gz \
    && mv ursim-${URSIMVERSION} ursimpkg \
    && chown -R $URSIM_USER:$URSIM_USER ursimpkg
