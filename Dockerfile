FROM nvidia/cuda:11.3.0-devel-ubuntu20.04
MAINTAINER Masahiro Mochizuki <masahiro.mochizuki.dev@gmail.com>
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget cmake build-essential zlib1g-dev locales sudo swig \
    gfortran pkg-config libpng-dev libfreetype6-dev libboost-all-dev \
    python3-pip liblapack-dev python3-dev libffi-dev
RUN ln -sf /usr/bin/python3.8 /usr/bin/python

RUN apt-get -y clean && rm -rf /var/lib/apt/lists/

RUN mkdir /.local && chmod o+w /.local
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

WORKDIR /tmp

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install lightgbm==3.2.1 --install-option="--gpu" --install-option="--opencl-include-dir=/usr/local/cuda/include/" --install-option="--opencl-library=/usr/local/cuda/lib64/libOpenCL.so"
#RUN pip install catboost==0.16.2

RUN groupadd user && \
    useradd  user -g user -G sudo -m
USER user
RUN mkdir /home/user/work && chmod o+w /home/user/work
