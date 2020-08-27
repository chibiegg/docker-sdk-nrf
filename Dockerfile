FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive


# Install Dependencies
RUN apt-get update && apt-get install -y \
  git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget curl \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev

RUN pip3 install -U west


# Install Toolchain
ARG TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2?revision=108bd959-44bd-4619-9c19-26187abf5225&la=en&hash=E788CE92E5DFD64B2A8C246BBA91A249CB8E2D2D"
RUN mkdir -p /opt
RUN curl -SL "${TOOLCHAIN_URL}" | bzip2 -dc | tar -xC /opt
RUN mv /opt/gcc-arm-none-eabi-* /opt/gnuarmemb
ENV PATH "/opt/gnuarmemb/bin:$PATH"
RUN ls /opt && ls /opt/gnuarmemb

# Install SDK
ARG NCS_VERSION="master"
RUN mkdir -p /opt/ncs
WORKDIR /opt/ncs

RUN west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NCS_VERSION} \
  && west update && west zephyr-export

RUN pip3 install -r zephyr/scripts/requirements.txt
RUN pip3 install -r nrf/scripts/requirements.txt
RUN pip3 install -r bootloader/mcuboot/scripts/requirements.txt

# Set Environment
ENV ZEPHYR_TOOLCHAIN_VARIANT "gnuarmemb"
ENV GNUARMEMB_TOOLCHAIN_PATH "/opt/gnuarmemb"
ENV ZEPHYR_BASE "/opt/ncs/zephyr"
