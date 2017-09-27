FROM tensorflow/tensorflow:latest-gpu-py3

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

USER root

RUN apt-get autoclean \
    && apt-get clean all \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -f -y --no-install-recommends && \
    apt-get upgrade -y --no-install-recommends

# clean again
RUN apt-get autoclean \
    && apt-get clean all \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
