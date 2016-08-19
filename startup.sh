#!/bin/sh
PIDFILE=/var/run/charon.pid /usr/sbin/ipsec start
sleep 2
ipsec up L2TP-PSK
sleep 2
ipsec statusall
sleep 2
(sleep 3 && echo "c myVPN" > /var/run/xl2tpd/l2tp-control) &
/usr/sbin/xl2tpd -p /var/run/xl2tpd.pid -c /etc/xl2tpd/xl2tpd.conf -C /var/run/xl2tpd/l2tp-control -D
