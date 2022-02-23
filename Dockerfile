FROM debian:stretch-slim

RUN  set -x \
     && apt-get -qq update \
     && apt-get -qq upgrade \
     && apt-get -qq install \
         debian-archive-keyring \
         curl \
         gnupg \
         apt-transport-https  \
     git \
     libtool m4 automake python-docutils make\
     \
     && curl -Ss -L https://packagecloud.io/varnishcache/varnish66/gpgkey | apt-key add - \
     && printf "%s\n%s" \
         "deb https://packagecloud.io/varnishcache/varnish66/debian/ stretch main" \
         "deb-src https://packagecloud.io/varnishcache/varnish66/debian/ stretch main" \
     > "/etc/apt/sources.list.d/varnishcache_varnish66.list" \
     && apt-get -qq update \
     && apt-get -qq install varnish varnish-dev \
     && mkdir -p /tmp/vmod \
     && cd /tmp/vmod \
     && git clone https://code.uplex.de/uplex-varnish/varnish-objvar.git \
     && cd varnish-objvar \
     && git checkout 6.6 \
     && ./bootstrap \
     && make \
     && make install \
     && apt-get -qq purge curl gnupg \
     && apt-get -qq autoremove \
     && apt-get -qq autoclean \
     && rm -rf /var/cache/*
