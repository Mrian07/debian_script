#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin openvpn package installation                  "
echo "====================================================="

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

apt-get -y install easy-rsa
touch /usr/share/easy-rsa/pki/.rnd
apt-get -y install openvpn
systemctl stop openvpn
systemctl disable openvpn

cd /usr/share/easy-rsa || exit
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch gen-dh 2048
./easyrsa --batch build-server-full server nopass
cd && cp -R /usr/share/easy-rsa/pki /etc/openvpn/

[[ -d /etc/openvpn/server ]] && rm -d /etc/openvpn/server
cat  >/etc/openvpn/tcp.conf <<-EOFTCP
port 2279
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.1.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
keepalive 10 120
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/access.log
verb 3
mute 20
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
EOFTCP

echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv FRIENDLY_NAME ${DOMAIN}
setenv CLIENT_CERT 0

client
dev tun
proto tcp
remote $DOMAIN 2279
http-proxy $DOMAIN 3128
compress lz4-v2
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/openvpn-tcp.ovpn

{
    echo ""
    echo "<ca>"
    cat /etc/openvpn/pki/ca.crt
    echo "</ca>"
} >>/etc/openvpn/client/openvpn-tcp.ovpn
cp /etc/openvpn/client/openvpn-tcp.ovpn /usr/share/nginx/html/openvpn-tcp.ovpn

cat >/etc/openvpn/tls.conf <<-EOFTLS
port 2751
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.1.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
route $IPADDR 255.255.255.255 net_gateway
duplicate-cn
keepalive 10 120
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/access.log
verb 3
mute 20
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
EOFTLS

echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv FRIENDLY_NAME ${DOMAIN}
setenv CLIENT_CERT 0

client
dev tun
proto tcp
remote $DOMAIN 2751
http-proxy $DOMAIN 3128
compress lz4-v2
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/openvpn-tls.ovpn

{
    echo ""
    echo "<ca>"
    cat /etc/openvpn/pki/ca.crt
    echo "</ca>"
} >>/etc/openvpn/client/openvpn-tls.ovpn
cp /etc/openvpn/client/openvpn-tls.ovpn /usr/share/nginx/html/openvpn-tls.ovpn

cat  >/etc/openvpn/ohp.conf <<-EOFOHP
port 2834
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.1.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
keepalive 10 120
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/access.log
verb 3
mute 20
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
EOFOHP

echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv FRIENDLY_NAME ${DOMAIN}
setenv CLIENT_CERT 0

client
dev tun
proto tcp
remote $DOMAIN 2834
http-proxy $DOMAIN 8000
compress lz4-v2
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/openvpn-ohp.ovpn

{
    echo ""
    echo "<ca>"
    cat /etc/openvpn/pki/ca.crt
    echo "</ca>"
} >>/etc/openvpn/client/openvpn-ohp.ovpn
cp /etc/openvpn/client/openvpn-ohp.ovpn /usr/share/nginx/html/openvpn-ohp.ovpn

systemctl enable openvpn@tcp
systemctl enable openvpn@tls
systemctl enable openvpn@ohp

rm ~/openvpn.sh
echo "====================================================="
echo " Name: openvpn.sh                                    "
echo " Desc: Script to install openvpn automatic           "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5