#! /bin/bash
set -e \
    && export UR_DOWNLOAD_SITE="https://s3-eu-west-1.amazonaws.com/ur-support-site/28546/ursim-3.4.1-59.tar.gz" \
    && export URSIMVERSION="3.4.1-59"  \
    && export INSTALL_DIR=$1  \
    && export URSIM_USER=$2  \
    && echo "INSTALL_DIR: $INSTALL_DIR \n URSIM_USER: $URSIM_USER" \
    \
    && echo "install ursim" > /dev/null \
    && cd $INSTALL_DIR && wget -q -O ursim.tar.gz ${UR_DOWNLOAD_SITE} && tar -xvzf ursim.tar.gz && cd ursim-${URSIMVERSION} \
    \
    && echo "delete 36-37 lines for no xterm exit" > /dev/null \
    && sed -i '36,37c \\t echo \"just ignore xterm warning\" ' ./install.sh \
    && sed -i 's/pkexec bash -c/bash -c/g' ./install.sh \
    && sed -i 's/apt-get -y install/apt-get -y install -q --no-install-recommends/g' ./install.sh \
    && sed -i '64,75d' ./install.sh  \
    && sed -i '26a \ echo \"debug: in function installDaemonManager() \"' ./install.sh \
    && sed -i '65a echo \"debug: before pushd, after installDaemonManager\"' ./install.sh \
    && sed -i '66a echo \"debug: after pushd\"' ./install.sh  \
    && echo "echo \" installation done! \""  >> ./install.sh \
    && ./install.sh \
    && cd .. && rm -f ./ursim.tar.gz \
    && mv ursim-${URSIMVERSION} ursimpkg \
    && chown -R $URSIM_USER:$URSIM_USER ursimpkg
