FROM debian:buster-slim
MAINTAINER Zerginator

# Much innformation about how to build this on Debian 10 comes from the open source docker build
# https://github.com/LinearTapeFileSystem/Debian10-Build/blob/master/Dockerfile

RUN echo "---------------- Installing tools" && \
    apt update && \
    apt -y install --no-install-recommends git ca-certificates curl && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

RUN echo "---------------- Installing dependencies and compiling source" && \
    apt update && \
    apt -y install --no-install-recommends build-essential automake autoconf libtool pkg-config icu* libicu* icu-devtools libicu-dev libxml2-dev uuid-dev fuse libfuse-dev libsnmp-dev pandoc tmux mt-st&& \
    curl --output /usr/bin/icu-config https://raw.githubusercontent.com/LinearTapeFileSystem/Debian10-Build/master/icu-config && \
    chmod +x /usr/bin/icu-config && \
    cd /tmp && \
    git clone https://github.com/LinearTapeFileSystem/ltfs.git && \
    cd ltfs && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig -v && \
    cd .. && \
    git clone https://github.com/scsitape/stenc.git && \
    cd stenc/ && \
    autoreconf --install && \
    ./autogen.sh && \
    ./configure  && \
    make check  && \
    make && \
    make install && \
    cd .. && \
    rm -rf stenc  && \
    rm -rf ltfs && \
    rm -rf /var/lib/apt/lists/* && \
    apt remove -y *-dev && \
    apt clean

WORKDIR /
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
CMD [ "ls" ]
