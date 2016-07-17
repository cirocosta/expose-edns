FROM alpine:3.4

RUN set -x && \
    apk add --update --no-cache socat

ADD ./entrypoint.sh /usr/local/bin/entrypoint

EXPOSE 53/udp
ENTRYPOINT [ "entrypoint" ]
CMD [ "-any" ]

