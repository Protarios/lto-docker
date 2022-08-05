FROM debian:buster-slim

# Much innformation about how to build this on Debian 10 comes from the open source docker build
# https://github.com/LinearTapeFileSystem/Debian10-Build/blob/master/Dockerfile

RUN echo "---------------- Installing tools" && \
    apt update && \
    apt -y install --no-install-recommends git ca-certificates curl && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

COPY qtmltfs-2.4.0.2-1.tar.gz /tmp/
RUN echo "---------------- Installing dependencies and compiling source" && \
    apt update && \
    apt -y install --no-install-recommends build-essential automake autoconf libtool pkg-config icu* libicu* icu-devtools libicu-dev libxml2-dev uuid-dev fuse libfuse-dev libsnmp-dev && \
    curl --output /usr/bin/icu-config https://raw.githubusercontent.com/LinearTapeFileSystem/Debian10-Build/master/icu-config && \
    chmod +x /usr/bin/icu-config && \
    cd /tmp && \
    tar -xvf qtmltfs-2.4.0.2-1.tar.gz && \
    cd qtmltfs2.4 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig -v && \
    cd .. && \
    rm -rf ltfs && \
    rm -rf /var/lib/apt/lists/* && \
    apt remove -y *-dev && \
    apt clean

WORKDIR /
ENTRYPOINT ["ltfs"]
