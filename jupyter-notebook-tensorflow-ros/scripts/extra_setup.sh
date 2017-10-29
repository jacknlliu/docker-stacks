#!/usr/bin/env bash

JUPYTER_USER_NAME=jovyan

# update sympy to fix some bugs
conda update -n root -y sympy

# add galgebra sympy module
cd /opt && git clone -b py3_compat https://github.com/micahscopes/galgebra && \
cd /opt/galgebra

source /opt/conda/bin/activate root

python setup.py sdist && pip install dist/*.tar.gz

# install ipyparallel
pip install ipyparallel keras

source /opt/conda/bin/deactivate


# set jupyter enable ipyparallel, refer to https://github.com/ipython/ipyparallel/issues/170
su - $JUPYTER_USER_NAME
source /opt/conda/bin/activate root

jupyter serverextension enable --py ipyparallel --user
jupyter nbextension install --py ipyparallel --user
jupyter nbextension enable --py ipyparallel --user

source /opt/conda/bin/deactivate

# for keep environment not use sudo su root
exit

# clean temp directory
rm -rf /opt/galgebra
