#!/bin/sh

set -e
set -o nounset
source ${SECRET_FOLDER}/vpn.env

# template out all the config files using env vars
sed -i 's/right=.*/right='$VPN_SERVER_IPV4'/' /etc/ipsec.conf
echo ': PSK "'$VPN_PSK'"' > /etc/ipsec.secrets
sed -i 's/lns = .*/lns = '$VPN_SERVER_IPV4'/' /etc/xl2tpd/xl2tpd.conf
sed -i 's/name .*/name '$VPN_USERNAME'/' /etc/ppp/options.l2tpd.client

VPN_PASSWORD=$(echo ${VPN_PASSWORD} | sed 's/\//\\\//g')
sed -i 's/password .*/password '$VPN_PASSWORD'/' /etc/ppp/options.l2tpd.client

# startup ipsec tunnel
PIDFILE=/var/run/charon.pid /usr/sbin/ipsec start
sleep 2
ipsec up L2TP-PSK
sleep 2
ipsec statusall
sleep 2

# startup xl2tpd ppp daemon then send it a connect command
(sleep 10 && echo "c myVPN" > /var/run/xl2tpd/l2tp-control && sleep 5 && /setup_routes.sh > /tmp/setup_route.log 2>&1) &
exec /usr/sbin/xl2tpd -p /var/run/xl2tpd.pid -c /etc/xl2tpd/xl2tpd.conf -C /var/run/xl2tpd/l2tp-control -D
