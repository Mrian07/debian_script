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
apt-get -y install openvpn
apt-get -y install obfsproxy
systemctl stop openvpn
systemctl disable openvpn

cd /usr/share/easy-rsa
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch gen-dh 2048
./easyrsa --batch build-server-full server nopass
cd && cp -R /usr/share/easy-rsa/pki /etc/openvpn/

if [[ ! -d /usr/lib/x86_64-linux-gnu/openvpn/plugins ]]; then
  mkdir -p /usr/lib/x86_64-linux-gnu/openvpn/plugins
fi
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so \
/usr/lib/openvpn/plugins/auth-pam.so

[[ -d /etc/openvpn/server ]] && rm -d /etc/openvpn/server
cat  >/etc/openvpn/server-tcp.conf <<-EOFTCP
# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
;local a.b.c.d
port 1194
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
;topology subnet
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
keepalive 10 120
;tls-auth ta.key 0
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
max-clients 127
user nobody
group nobody
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/openvpn.log
verb 3
mute 20
explicit-exit-notify 1
;script-security 2
;block-outside-dns
verify-client-cert none
plugin /usr/lib/openvpn/plugins/auth-pam.so login
username-as-common-name
EOFTCP

echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv CLIENT_CERT 0
setenv FRIENDLY_NAME "${DOMAIN}_TCP"
client
dev tun
proto tcp
remote cybertize.ml 1194
;resolv-retry infinite
;nobind
;user nobody
;group nobody
persist-key
persist-tun
http-proxy-retry
http-proxy 157.223.42.127 8080
mute-replay-warnings
remote-cert-tls server
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
verb 3
mute 20" >/etc/openvpn/client/client-tcp.ovpn

echo "" >>/etc/openvpn/client/client-tcp.ovpn
echo "<ca>" >>/etc/openvpn/client/client-tcp.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tcp.ovpn
echo "</ca>" >>/etc/openvpn/client/client-tcp.ovpn
cp /etc/openvpn/client/client-tcp.ovpn /var/www/html/client-tcp.ovpn

cat >/etc/openvpn/server-tls.conf <<-EOFTLS
# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
;local a.b.c.d
port 994
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
;topology subnet
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
;push "route 192.168.10.0 255.255.255.0"
;push "route 192.168.20.0 255.255.255.0"
route $IPADDR 255.255.255.255 net_gateway
push "redirect-gateway def1"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
keepalive 10 120
;tls-auth ta.key 0
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
max-clients 127
user nobody
group nobody
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/openvpn.log
verb 3
mute 20
explicit-exit-notify 1
;script-security 2
;block-outside-dns
verify-client-cert none
plugin /usr/lib/openvpn/plugins/auth-pam.so login
username-as-common-name
EOFTLS

echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv CLIENT_CERT 0
setenv FRIENDLY_NAME "${DOMAIN}_TLS"
client
dev tun
proto tcp
remote cybertize.ml 1194
;resolv-retry infinite
;nobind
;user nobody
;group nobody
persist-key
persist-tun
http-proxy-retry
http-proxy 157.223.42.127 8080
mute-replay-warnings
remote-cert-tls server
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
verb 3
mute 20" >/etc/openvpn/client/client-tls.ovpn

echo "" >>/etc/openvpn/client/client-tls.ovpn
echo "<ca>" >>/etc/openvpn/client/client-tls.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tls.ovpn
echo "</ca>" >>/etc/openvpn/client/client-tls.ovpn
cp /etc/openvpn/client/client-tls.ovpn /var/www/html/client-tls.ovpn

cat >/etc/openvpn/server-tls.conf <<-EOFOBFS
# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
;local a.b.c.d
port 587
proto tcp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
;topology subnet
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
;push "route 192.168.10.0 255.255.255.0"
;push "route 192.168.20.0 255.255.255.0"
route $IPADDR 255.255.255.255 net_gateway
push "redirect-gateway def1"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
keepalive 10 120
;tls-auth /etc/openvpn/pki/ta.key 0
;tls-crypt /etc/openvpn/pki/ta.key
cipher AES-256-GCM
compress lz4-v2
push "compress lz4-v2"
max-clients 127
user nobody
group nobody
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/openvpn.log
verb 3
mute 20
explicit-exit-notify 1
;tls-version-min 1.2
;tls-cipher TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384
;tls-server
;ecdh-curve sect571r1
;tun-mtu 1500
;mssfix 1450
;script-security 2
;block-outside-dns
verify-client-cert none
plugin /usr/lib/openvpn/plugins/auth-pam.so login
username-as-common-name
EOFOBFS

  echo "# ----------------------------
# OPENVPN BY CYBERTIZE
# ----------------------------
setenv CLIENT_CERT 0
setenv FRIENDLY_NAME "${DOMAIN}_OBFS"
client
dev tun
proto tcp
remote $DOMAIN 587
resolv-retry infinite
nobind
persist-key
persist-tun
tls-client
remote-cert-tls server
cipher AES-256-GCM
script-security 2
block-outside-dns
auth-user-pass
comp-lzo
verb 3
mute 20
socks-proxy 127.0.0.1 1587" >/etc/openvpn/client/client-obfs.ovpn

echo "" >>/etc/openvpn/client/client-obfs.ovpn
echo "<ca>" >>/etc/openvpn/client/client-obfs.ovpn
cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-obfs.ovpn
echo "</ca>" >>/etc/openvpn/client/client-obfs.ovpn
cp /etc/openvpn/client/client-obfs.ovpn /var/www/html/client-obfs.ovpn

systemctl enable openvpn@server-tcp &>/dev/null
systemctl enable openvpn@server-tls &>/dev/null
systemctl enable openvpn@server-obfs &>/dev/null
rm ~/openvpn.sh

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
systemctl start obfsproxy
systemctl enable obfsproxy

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} openvpn.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install openvpn automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 5