FROM debian:stable

ARG version=24.10.1
ENV version=$version

ARG target=ath79-generic
ENV target=$target

ARG profile=tplink_archer-c60-v2
ENV profile=$profile

ARG packages=
ENV packages=$packages

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get -y install build-essential file libncurses-dev zlib1g-dev gawk git \
    gettext libssl-dev xsltproc rsync wget unzip python3 python3-distutils zstd


RUN mkdir /openwrt
WORKDIR /openwrt

RUN if [ "${version}" = "snapshots" ]; then \
    wget https://downloads.openwrt.org/snapshots/targets/${target//-//}/openwrt-imagebuilder-${target}.Linux-x86_64.tar.zst; \
    else \
    wget https://downloads.openwrt.org/releases/${version}/targets/${target//-//}/openwrt-imagebuilder-${version}-${target}.Linux-x86_64.tar.zst; \
    fi

RUN tar --zstd -x -f openwrt-imagebuilder-*
RUN rm openwrt-imagebuilder-*.tar.zst
RUN mv openwrt-imagebuilder-* openwrt-imagebuilder

WORKDIR /openwrt/openwrt-imagebuilder



RUN make image PROFILE=${profile} PACKAGES="${packages}"

