#!/bin/sh -x

set -o nounset

# wait for ppp

while true
do
echo looking for ppp
ifconfig | grep ppp && break
sleep 10
done
echo ppp established

source ${SECRET_FOLDER}/vpn.env

VIA=$(ip route | grep 'default via' | awk '{print $3}')

route add ${VPN_SERVER_IPV4} gw ${VIA}
route add default dev ppp0
