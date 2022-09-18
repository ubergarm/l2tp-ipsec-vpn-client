l2tp-ipsec-vpn-client
===
[![](https://images.microbadger.com/badges/image/ubergarm/l2tp-ipsec-vpn-client.svg)](https://microbadger.com/images/ubergarm/l2tp-ipsec-vpn-client) [![](https://images.microbadger.com/badges/version/ubergarm/l2tp-ipsec-vpn-client.svg)](https://microbadger.com/images/ubergarm/l2tp-ipsec-vpn-client) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/ubergarm/l2tp-ipsec-vpn-client/blob/master/LICENSE)

A tiny Alpine based docker image to quickly setup an L2TP over IPsec VPN client w/ PSK.

## Motivation
Does your office or a client have a VPN server already setup and you
just need to connect to it? Do you use Linux and are jealous that the
one thing a MAC can do better is quickly setup this kind of VPN? Then
here is all you need:

1. VPN Server Address
2. Pre Shared Key
3. Username
4. Password
5. Optionally, list of networks to route through VPN

## Run
Setup environment variables for your credentials and config:

    export VPN_SERVER_IPV4='1.2.3.4'
    export VPN_PSK='my pre shared key'
    export VPN_USERNAME='myuser@myhost.com'
    export VPN_PASSWORD='mypass'
    export VPN_ROUTES='10.0.0.0/8+172.16.0.0/12+...' (separated by '+')

Now run it (you can daemonize of course after debugging):

    docker run --rm -it --privileged --net=host \
               -v /lib/modules:/lib/modules:ro \
               -e VPN_SERVER_IPV4 \
               -e VPN_PSK \
               -e VPN_USERNAME \
               -e VPN_PASSWORD \
               -e VPN_ROUTES \
                  ubergarm/l2tp-ipsec-vpn-client

## Route
Routes to destinations listed in VPN\_ROUTES are added automatically.
This fails if there is an existing route to named destination.
To add a route through VPN along with existing one,
assign a unique metric to existing route before starting VPN container.
For example, to effectively replace and then restore default route:

    # list current route
    ip route show default
    # change metric for current route
    sudo route add -net default gw 10.0.1.1 dev eth0 metric 100
    sudo route del -net default gw 10.0.1.1 dev eth0

## Test
You can see if your IP address changes after adding appropriate routes e.g.:

    curl icanhazip.com

## Debugging
On your VPN client localhost machine you may need to `sudo modprobe af_key`
if you're getting this error when starting:
```
pluto[17]: No XFRM/NETKEY kernel interface detected
pluto[17]: seccomp security for crypto helper not supported
```

## Strongswan
The previous `strongswan` based version of this docker image is still available on docker hub here:
```bash
docker pull ubergarm/l2tp-ipsec-vpn-client:strongswan
```

## TODO
- [x] `ipsec` connection works
- [x] `xl2tpd` ppp0 device creates
- [x] Can forward traffic through tunnel from host
- [x] Pass in credentials as environment variables
- [x] Dynamically template out the default config files with `sed` on start
- [x] Update to use `libreswan` instead of `strongswan`
- [ ] See if this can work without privileged and net=host modes to be more portable

## References
* [royhills/ike-scan](https://github.com/royhills/ike-scan)
* [libreswan reference config](https://libreswan.org/wiki/VPN_server_for_remote_clients_using_IKEv1_with_L2TP)
* [Useful Config Example](https://lists.libreswan.org/pipermail/swan/2016/001921.html)
* [libreswan and Cisco ASA 5500](https://sgros.blogspot.com/2013/08/getting-libreswan-connect-to-cisco-asa.html)
* [NetDev0x12 IPSEC and IKE Tutorial](https://youtu.be/7oldcYljp4U?t=1586)
