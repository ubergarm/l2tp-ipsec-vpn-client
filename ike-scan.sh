#!/bin/sh

#
# apt-get install ike-scan || brew install ike-scan
# sudo ike-scan.sh <target_vpn_server_ipv4>
#
# Source:
# https://github.com/nm-l2tp/network-manager-l2tp/wiki/Known-Issues#querying-vpn-server-for-its-ikev1-algorithm-proposals
#

# Encryption algorithms: 3des=5, aes128=7/128, aes192=7/192, aes256=7/256
ENCLIST="5 7/128 7/192 7/256"
# Hash algorithms: md5=1, sha1=2, sha256=5, sha384=6, sha512=7
HASHLIST="1 2 5 6 7"
# Diffie-Hellman groups: 1, 2, 5, 14, 15, 19, 20, 21
GROUPLIST="1 2 5 14 15 19 20 21"
# Authentication method: Preshared Key=1
AUTH=1

for ENC in $ENCLIST; do
   for HASH in $HASHLIST; do
       for GROUP in $GROUPLIST; do
          echo ike-scan --trans=$ENC,$HASH,$AUTH,$GROUP -M "$@"
          ike-scan --trans=$ENC,$HASH,$AUTH,$GROUP -M "$@"
      done
   done
done
