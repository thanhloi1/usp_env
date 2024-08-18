FROM ubuntu:20.04

ENV MAKE_JOBS=8
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y software-properties-common wget g++ git psmisc && \
    apt-get clean

# Add Mosquitto PPA and install dependencies
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && \
    apt-get update && \
    apt-get -y install \
        libssl-dev \
        libcurl4-openssl-dev \
        libsqlite3-dev \
        libc-ares-dev \
        libz-dev \
        autoconf \
        automake \
        libtool \
        libmosquitto-dev \
        libwebsockets-dev \
        pkg-config \
        make \
        lua5.1 \
        liblua5.1-0-dev \
        libjson-c-dev \
        mosquitto \
        mosquitto-clients && \
    apt-get clean

# Install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && \
    tar -zxvf cmake-3.20.0.tar.gz && \
    cd cmake-3.20.0 && ./bootstrap && make && make install

# Install libubox
RUN git clone https://git.openwrt.org/project/libubox.git && \
    cd libubox && \
    cmake . && \
    make && \
    make install

# Install ubus
RUN git clone git://git.openwrt.org/project/ubus.git && \
    cd ubus && \
    cmake . && \
    make && \
    make install

# Install uci
RUN git clone git://git.openwrt.org/project/uci.git && \
    cd uci && \
    cmake . && \
    make && \
    make install && ldconfig

# Clone the obuspa-test-controller repository
RUN git clone https://dev.iopsys.eu/bbf/obuspa-test-controller.git /obuspa

# Build and install obuspa
WORKDIR /obuspa
RUN autoreconf -fi && \
    ./configure && \
    make -j${MAKE_JOBS} && \
    make install

RUN rm -rf /obuspa

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the default Mosquitto MQTT port and the WebSockets port
EXPOSE 1883
EXPOSE 9001

# Set the entrypoint to the script that starts Mosquitto and runs the controller script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
