#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

[[ -e /etc/os-release ]] && source /etc/os-release

if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

if [[ $ID == "debian" ]]; then
  debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
  if [[ $debianVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

apt-get -y install easy-rsa
openssl rand -out /usr/share/easy-rsa/pki/.rnd -hex 256
apt-get -y install openvpn
systemctl stop openvpn
systemctl disable openvpn

apt-get -y install obfsproxy
systemctl stop obfsproxy

cd /usr/share/easy-rsa
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch gen-dh 2048
./easyrsa --batch build-server-full server nopass
cd && cp -R /usr/share/easy-rsa/pki /etc/openvpn/

[[ -d /etc/openvpn/server ]] && rm -d /etc/openvpn/server
cat  >/etc/openvpn/default.conf <<-EOFTCP
port 1194
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
cipher AES-256-GCM
comp-lzo
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
setenv FRIENDLY_NAME "${DOMAIN}_TCP"
setenv CLIENT_CERT 0

client
dev tun
proto tcp
comp-lzo
remote $DOMAIN 1194
http-proxy $DOMAIN 3128
remote-cert-tls server
cipher AES-256-GCM
auth-user-pass" >/etc/openvpn/client/client-tcp.ovpn

echo "" >>/etc/openvpn/client/client-tcp.ovpn
echo "<ca>" >>/etc/openvpn/client/client-tcp.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tcp.ovpn
echo "</ca>" >>/etc/openvpn/client/client-tcp.ovpn
cp /etc/openvpn/client/client-tcp.ovpn /var/www/html/client-tcp.ovpn

cat >/etc/openvpn/stunnel.conf <<-EOFTLS
port 994
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
route $IPADDR 255.255.255.255 net_gateway
cipher AES-256-GCM
comp-lzo
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
setenv FRIENDLY_NAME "${DOMAIN}_TLS"
setenv CLIENT_CERT 0

client
dev tun
proto tcp
comp-lzo
remote $DOMAIN 994
http-proxy $DOMAIN 3128
remote-cert-tls server
cipher AES-128-GCM
auth-user-pass" >/etc/openvpn/client/client-tls.ovpn

echo "" >>/etc/openvpn/client/client-tls.ovpn
echo "<ca>" >>/etc/openvpn/client/client-tls.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tls.ovpn
echo "</ca>" >>/etc/openvpn/client/client-tls.ovpn
cp /etc/openvpn/client/client-tls.ovpn /var/www/html/client-tls.ovpn

cat >/etc/openvpn/obfsproxy.conf <<-EOFOBFS
# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
port 587
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
route $IPADDR 255.255.255.255 net_gateway
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
;tls-crypt /etc/openvpn/pki/ta.key
cipher AES-256-GCM
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/access.log
verb 3
mute 20
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384
tls-server
ecdh-curve sect571r1
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
EOFOBFS

  echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv FRIENDLY_NAME "${DOMAIN}_OBFS"
setenv CLIENT_CERT 0

client
tls-client
dev tun
proto tcp
comp-lzo
remote $DOMAIN 587
remote-cert-tls server
cipher AES-256-GCM
socks-proxy 127.0.0.1 1587
auth-user-pass" >/etc/openvpn/client/client-obfs.ovpn

echo "" >>/etc/openvpn/client/client-obfs.ovpn
echo "<ca>" >>/etc/openvpn/client/client-obfs.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-obfs.ovpn
echo "</ca>" >>/etc/openvpn/client/client-obfs.ovpn
cp /etc/openvpn/client/client-obfs.ovpn /var/www/html/client-obfs.ovpn

systemctl enable openvpn@default
systemctl enable openvpn@stunnel
systemctl enable openvpn@obfsproxy

echo "Description=obfsproxy Service
Documentation=https://github.com/cybertize/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/obfsproxy --log-file=/var/log/obfsproxy.log --log-min-severity=info obfs3 --dest=127.0.0.1:587 server 0.0.0.0:1587
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/obfsproxy.service
systemctl enable obfsproxy

rm ~/openvpn.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} openvpn.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install openvpn automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
