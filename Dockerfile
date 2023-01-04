FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt update \
    && apt install -y git gcc-arm-none-eabi make libtool pkgconf autoconf automake stlink-tools python3.9 \
    texinfo libusb-1.0-0 libusb-1.0-0-dev libjaylink0 \
    && ln -s /usr/bin/python3.9 /usr/bin/python3 \
    && apt -y clean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN git clone --recursive https://github.com/blackmagic-debug/blackmagic.git \
    && cd blackmagic/ \
    && make PROBE_HOST=swlink ST_BOOTLOADER=1
