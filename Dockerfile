FROM alpine:3.4

ENV LANG C.UTF-8
RUN apk update

RUN set -x && \
    apk add --no-cache \
              strongswan \
              xl2tpd \
              ppp \
              openssh \
              iputils \
    && mkdir -p /var/run/xl2tpd \
    && touch /var/run/xl2tpd/l2tp-control

COPY ipsec.conf /etc/ipsec.conf
COPY ipsec.secrets /etc/ipsec.secrets
COPY xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY options.l2tpd.client /etc/ppp/options.l2tpd.client
COPY startup.sh /
COPY setup_routes.sh /

CMD ["/startup.sh"]
