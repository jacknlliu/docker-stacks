#! /bin/bash
set -e \
    && export UR_DOWNLOAD_SITE="https://s3-eu-west-1.amazonaws.com/ur-support-site/51847/URSim_Linux-5.3.1.64192.tar.gz" \
    && export URSIMVERSION="5.3.1.64192"  \
    && export INSTALL_DIR=$1  \
    && export URSIM_USER=$2  \
    && echo "INSTALL_DIR: $INSTALL_DIR \n URSIM_USER: $URSIM_USER" \
    \
    && echo "install ursim" > /dev/null \
    && cd $INSTALL_DIR && wget -q -O ursim.tar.gz ${UR_DOWNLOAD_SITE} && tar -xvzf ursim.tar.gz && mv ursim-${URSIMVERSION} ursimpkg && cd ursimpkg \
    \
    && echo "delete 57 lines for not installing java7" > /dev/null \
    && sed -i '57c \\t echo \"just ignore install java7\" ' ./install.sh \
    && echo "delete 50-51 lines for no xterm exit" > /dev/null \
    && sed -i '50,51c \\t echo \"just ignore xterm warning\" ' ./install.sh \
    && sed -i 's/pkexec bash -c/bash -c/g' ./install.sh \
    && sed -i 's/apt-get -y install/apt-get -y install -q --no-install-recommends/g' ./install.sh \
    && sed -i '86,$d' ./install.sh  \
    && sed -i 's/libcurl3/libcurl3:i386/g' ./install.sh  \
    && sed -i 's/fonts-ipafont//g' ./install.sh  \
    && sed -i 's/fonts-baekmuk//g' ./install.sh  \
    && sed -i 's/fonts-nanum//g' ./install.sh  \
    && sed -i 's/fonts-arphic-uming//g' ./install.sh  \
    && sed -i 's/fonts-arphic-ukai//g' ./install.sh  \
    && echo "echo \" installation done! \""  >> ./install.sh \
    && ./install.sh \
    && cd .. && rm -f ./ursim.tar.gz \
    && chown -R $URSIM_USER:$URSIM_USER ursimpkg \
    && chmod a+rx  ursimpkg/URControl
