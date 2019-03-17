FROM nvidia/cuda:10.1-devel-ubuntu18.04
MAINTAINER Masahiro Mochizuki <masahiro.mochizuki.dev@gmail.com>

RUN apt-get update && \
    apt-get install -y wget cmake build-essential zlib1g-dev locales sudo swig

RUN mkdir /.local && chmod o+w /.local
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN groupadd user && \
    useradd  user -g user -G sudo -m
USER user
RUN mkdir /home/user/work && chmod o+w /home/user/work

WORKDIR /tmp

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/user/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /home/user/miniconda3/bin:$PATH

ADD environment.yml .
RUN conda env update -f=environment.yml
ENV BOOST_ROOT /home/user/miniconda3/
RUN pip install lightgbm --install-option=--gpu --install-option="--opencl-include-dir=/usr/local/cuda/include/" --install-option="--opencl-library=/usr/local/cuda/lib64/libOpenCL.so"
