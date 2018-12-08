docker build --no-cache -t l2tp-ipsec-vpn-client . && \
exec docker run -ti \
-e SECRET_FOLDER=/mnt/secrets \
-v /mnt/secrets/vpn.env:/mnt/secrets/vpn.env \
--privileged \
--rm \
--net=host \
--name l2tp-ipsec-vpn-client \
l2tp-ipsec-vpn-client $*


