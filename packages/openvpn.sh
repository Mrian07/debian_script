#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
  getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  if [[ $getVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

apt-get -y install easy-rsa
touch /usr/share/easy-rsa/pki/.rnd
# openssl rand -out /usr/share/easy-rsa/pki/.rnd -hex 256
apt-get -y install openvpn
systemctl stop openvpn
systemctl disable openvpn

apt-get -y install obfsproxy
systemctl stop obfsproxy

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
http-proxy $DOMAIN 8080
compress lz4-v2
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/openvpn-tcp.ovpn

echo "" >>/etc/openvpn/client/openvpn-tcp.ovpn
echo "<ca>" >>/etc/openvpn/client/openvpn-tcp.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/openvpn-tcp.ovpn
echo "</ca>" >>/etc/openvpn/client/openvpn-tcp.ovpn
cp /etc/openvpn/client/openvpn-tcp.ovpn /var/www/html/openvpn-tcp.ovpn

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
http-proxy $DOMAIN 8080
compress lz4-v2
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/openvpn-tls.ovpn

echo "" >>/etc/openvpn/client/openvpn-tls.ovpn
echo "<ca>" >>/etc/openvpn/client/openvpn-tls.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/openvpn-tls.ovpn
echo "</ca>" >>/etc/openvpn/client/openvpn-tls.ovpn
cp /etc/openvpn/client/openvpn-tls.ovpn /var/www/html/openvpn-tls.ovpn

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

echo "" >>/etc/openvpn/client/openvpn-ohp.ovpn
echo "<ca>" >>/etc/openvpn/client/openvpn-ohp.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/openvpn-ohp.ovpn
echo "</ca>" >>/etc/openvpn/client/openvpn-ohp.ovpn
cp /etc/openvpn/client/openvpn-ohp.ovpn /var/www/html/openvpn-ohp.ovpn

systemctl enable openvpn@tcp
systemctl enable openvpn@tls
systemctl enable openvpn@ohp

rm ~/openvpn.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} openvpn.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install openvpn automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3