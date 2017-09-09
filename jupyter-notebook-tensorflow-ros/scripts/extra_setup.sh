#!/usr/bin/env bash

# update sympy to fix some bugs
conda update -n root -y sympy

# add galgebra sympy module
cd /opt && git clone -b py3_compat https://github.com/micahscopes/galgebra && \
cd /opt/galgebra && source activate root && python setup.py sdist && pip install dist/*.tar.gz \
&& source deactivate

rm -rf /opt/galgebra
