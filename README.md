l2tp-ipsec-vpn-client
===
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

## Build

    docker build -t ubergarm/l2tp-ipsec-vpn-client .

## Config
Setup the config or rebuild to suite your needs:

#### 1. `/etc/ipsec.conf`
Replace the IPV4 address of your VPN server in here.

#### 2. `/etc/ipsec.secrets`
Replace the shared pass key in here.

#### 3. `/etc/xl2tpd/xl2tpd.conf`
Replace the IPV4 address of your VPN server in here.

#### 4. `/etc/ppp/options.l2tpd.client`
Replace your username@hostname.com and password in here.

## Run

    docker run --rm -it --privileged --net=host \
               -v /lib/modules:/lib/modules:ro \
               -v `pwd`/ipsec.conf:/etc/ipsec.conf \
               -v `pwd`/ipsec.secrets:/etc/ipsec.secrets \
               -v `pwd`/xl2tpd.conf:/etc/xl2tpd/xl2tpd.conf \
               -v `pwd`/options.l2tpd.client:/etc/ppp/options.l2tpd.client \
                  ubergarm/l2tp-ipsec-vpn-client

## Route
From the host machine run these commands:

    # confirm the ppp0 link and get the peer e.g. (192.0.2.1) IPV4 address
    ip a show ppp0
    # route traffic for a specific target ip through VPN tunnel address
    sudo ip route add 1.2.3.4 via 192.0.2.1 dev ppp0
    # route all traffice through VPN tunnel address
    sudo ip route add default via 192.0.2.1 dev ppp0
    # or
    sudo route add -net default gw 192.0.2.1 dev ppp0
    # and delete old default routes e.g.
    sudo route del -net default gw 10.0.1.1 dev eth0
    # when your done add your normal routes and delete the VPN routes
    # or just `docker stop` and you'll probably be okay

## Test
You can see if your IP address changes after adding appropriate routes e.g.:

    curl icanhazip.com

## TODO
- [x] `ipsec` connection works
- [x] `xl2tpd` ppp0 device creates
- [x] Can forward traffic through tunnel from host
- [ ] Pass in credentials as environment variables
- [ ] Dynamically template out the default config files with `sed` on start
- [ ] See if this can work without privileged and net=host modes to be more portable

## References
[L2TP / IPsec VPN on Ubuntu 16.04](http://www.jasonernst.com/2016/06/21/l2tp-ipsec-vpn-on-ubuntu-16-04/)
