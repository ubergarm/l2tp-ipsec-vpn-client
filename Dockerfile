FROM alpine:3.4

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN set -x && \
    apk add --no-cache \
              strongswan \
              xl2tpd \
              ppp \
    && mkdir -p /var/run/xl2tpd \
    && touch /var/run/xl2tpd/l2tp-control

COPY startup.sh /

CMD ["/startup.sh"]
