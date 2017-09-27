FROM ubuntu:14.04

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

COPY . /bd_build

# if we have issues in the inherited image, we should upgrade this base image.
RUN apt-get update -y && apt-get upgrade -y --no-install-recommends

# install python3 and python2 and related tools
RUN apt-get install -y --no-install-recommends python3-pip python-pip python3-setuptools python-setuptools \
    && pip3 install --upgrade pip \
		&& pip2 install --upgrade pip

RUN /bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/fix_pam_bug.sh && \
	/bd_build/cleanup.sh

ENV DEBIAN_FRONTEND teletype

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

CMD ["/sbin/my_init"]
