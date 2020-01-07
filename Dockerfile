FROM ubuntu:bionic

ENV LIBFIXBUF_VERSION 2.4.0
ENV SILK_VERSION 3.19.0
ENV YAF_VERSION 2.11.0

# Volumes
VOLUME /netflow

# Upgrade/install packages
RUN apt-get update && \
    apt-get -y install \
    build-essential \
    libglib2.0-dev \
    liblzo2-2 \
    multiarch-support \
    zlib1g-dev \
    libgnutls28-dev \
    libpcap-dev \
    python2.7-dev \
    curl

# Download and build libfixbuf
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O https://tools.netsa.cert.org/releases/libfixbuf-$LIBFIXBUF_VERSION.tar.gz \
    && tar zxf libfixbuf-$LIBFIXBUF_VERSION.tar.gz \
    && cd /src/libfixbuf-$LIBFIXBUF_VERSION \
    && ./configure \
    && make \
    && make install \
    && rm -rf /src

# Download and build SiLK
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O https://tools.netsa.cert.org/releases/silk-$SILK_VERSION.tar.gz \
    && tar zxf silk-$SILK_VERSION.tar.gz \
    && cd /src/silk-$SILK_VERSION \
    && ./configure --enable-ipv6 --enable-data-rootdir=/netflow \
    && make \
    && make install \
    && rm -rf /src

# Download and build YAF
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O https://tools.netsa.cert.org/releases/yaf-$YAF_VERSION.tar.gz \
    && tar zxf yaf-$YAF_VERSION.tar.gz \
    && cd /src/yaf-$YAF_VERSION \
    && ./configure --enable-plugins --enable-mpls --enable-applabel \
    && make \
    && make install \
    && rm -rf /src

COPY entry.sh /usr/local/bin/
CMD ["/usr/local/bin/entry.sh"]