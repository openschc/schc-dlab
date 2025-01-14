# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 ubuntu:22.04
LABEL Description="CORE Docker Ubuntu Image"

ARG PREFIX=/usr/local
ARG BRANCH=master
ARG PROTOC_VERSION=3.19.6
ARG VENV_PATH=/opt/core/venv
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:${VENV_PATH}/bin"
WORKDIR /opt

# install system dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    sudo \
    wget \
    tzdata \
    libpcap-dev \
    libpcre3-dev \
    libprotobuf-dev \
    libxml2-dev \
    protobuf-compiler \
    unzip \
    uuid-dev \
    iproute2 \
    iputils-ping \
    tcpdump && \
    apt-get autoremove -y

# install core
RUN git clone https://github.com/coreemu/core && \
    cd core && \
    git checkout ${BRANCH} && \
    ./setup.sh && \
    PATH=/root/.local/bin:$PATH inv install -v -p ${PREFIX} && \
    cd /opt && \
    rm -rf ospf-mdr

# install emane
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    mkdir protoc && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d protoc && \
    git clone https://github.com/adjacentlink/emane.git && \
    cd emane && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make -j$(nproc)  && \
    make install && \
    cd src/python && \
    make clean && \
    PATH=/opt/protoc/bin:$PATH make && \
    ${VENV_PATH}/bin/python -m pip install . && \
    cd /opt && \
    rm -rf protoc && \
    rm -rf emane && \
    rm -f protoc-${PROTOC_VERSION}-linux-x86_64.zip

WORKDIR /root

# schc docker lab config
RUN apt-get install -y nano vim x11-xserver-utils wireshark net-tools
RUN pip install scapy cbor2 netifaces
COPY ./schc-ping.xml /root/.coregui/xmls/schc-ping.xml
COPY ./fond-simu.png /root/.coregui/backgrounds/fond-simu.png
COPY ./bash-config /root/bash-config
RUN cat /root/bash-config >> .bashrc && rm bash-config
COPY ./xterm-config /root/.Xresources

