#
# Dockerfile for pdnsd
#

FROM alpine
MAINTAINER Vincent.Gu <g@v-io.co>

ENV APP_DIR                     /srv/pdnsd
ENV INTERFACE                   127.0.0.1
ENV PORT                        53
ENV QUERY_METHOD                udp_tcp

EXPOSE $PORT/udp
EXPOSE $PORT/tcp

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# build software stack
ENV DEP pdnsd bash
RUN set -ex \
    && apk --update --no-cache add $DEP \
    && rm -rf /var/cache/apk/* \
    && ln -s /etc/pdnsd "$APP_DIR"

WORKDIR $APP_DIR
