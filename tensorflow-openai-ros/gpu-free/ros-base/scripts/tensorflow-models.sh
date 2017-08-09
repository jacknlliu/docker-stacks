#!/usr/bin/env bash

sudo apt-get install -y -q --no-install-recommends protobuf-compiler python3-pil python3-lxml

cd /opt/ && git clone https://github.com/tensorflow/models.git tensorflow-models
cd /opt/tensorflow-models && protoc object_detection/protos/*.proto --python_out=.

# From tensorflow/models/
export PYTHONPATH=$PYTHONPATH:/opt/tensorflow-models:/opt/tensorflow-models/slim
