FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Masahiro Mochizuki <masahiro.mochizuki.dev@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget cmake build-essential zlib1g-dev locales sudo swig \
    gfortran pkg-config libpng-dev libfreetype6-dev libboost-all-dev \
    python3 python3-pip python3-dev python3-setuptools
RUN ln -sf /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip

RUN wget --quiet https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list 
RUN apt-get update && apt-get install -y intel-mkl-2019.3-062
ENV LD_LIBRARY_PATH "/opt/intel/mkl/lib/intel64:/opt/intel/lib/intel64:$LD_LIBRARY_PATH"

RUN mkdir /.local && chmod o+w /.local
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

WORKDIR /tmp

COPY .numpy-site.cfg /root
COPY requirements.txt .
RUN pip install -r requirements.txt

RUN groupadd user && \
    useradd  user -g user -G sudo -m
USER user
RUN mkdir /home/user/work && chmod o+w /home/user/work
#RUN pip freeze
#RUN python -c "import numpy as np; np.show_config()"
#RUN python -c "import lightgbm"
