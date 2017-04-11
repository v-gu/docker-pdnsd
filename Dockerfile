#
# Dockerfile for pdnsd
#

FROM alpine
MAINTAINER Vincent.Gu <g@v-io.co>

ENV UDP_PORT   53
ENV TCP_PORT   53

EXPOSE $UDP_PORT/udp
EXPOSE $TCP_PORT/tcp

# build software stack
ENV DEP pdnsd
RUN set -ex \
    && apk --update --no-cache add $DEP \
    && rm -rf /var/cache/apk/*

# copy-in files
ADD pdnsd/ /srv/pdnsd/

ENTRYPOINT ["/usr/sbin/pdnsd", "-c", "/srv/pdnsd/pdnsd.conf"]
