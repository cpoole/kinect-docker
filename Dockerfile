FROM nvidia/cuda:9.0-devel-ubuntu17.04

COPY ./keyboard /etc/default/keyboard

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    libturbojpeg \
    libjpeg-turbo8-dev \
    libglfw3-dev \
    beignet-dev \
    libva-dev \
    libjpeg-dev \
    cuda \
    libopenni2-dev

ADD ./libfreenect2 /libfreenect2

WORKDIR libfreenect2

RUN mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/freenect2 \
    && make \
    && make install \
    && cp ../platform/linux/udev/90-kinect2.rules /etc/udev/rules.d/

RUN apt-get update && apt-get install -y \
    xvfb \
    xauth \
    x11vnc \
    x11-utils \
    x11-xserver-utils

ENV VIRTUALGL_VERSION 2.5.2

# install VirtualGL
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglu1-mesa-dev mesa-utils curl ca-certificates xterm && \
    curl -sSL https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb -o virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb && \
    dpkg -i virtualgl_*_amd64.deb && \
    /opt/VirtualGL/bin/vglserver_config -config +s +f -t && \
    rm virtualgl_*_amd64.deb

ENV PATH /usr/local/nvidia/bin:/opt/VirtualGL/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
#set to cl for non cuda
ENV LIBFREENECT2_PIPELINE cuda 
