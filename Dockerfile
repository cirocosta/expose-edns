FROM alpine:3.4

RUN set -x && \
    apk add --update --no-cache socat

EXPOSE 53/udp
CMD [ "socat", "UDP4-RECVFROM:53,fork", "UDP4-SENDTO:127.0.0.11:53" ]

