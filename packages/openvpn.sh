#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
NAME=$(grep -sw 'NAME' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')

function check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
  fi
}

function check_virtual() {
  if [ -f /proc/user_beancounters ]; then
    echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
  fi
}

function check_distro() {
  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
  else
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}

function head_section() {
  clear && echo
  echo -e "${RED}=====================================================${CLR}"
  echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
  echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
  echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
  echo -e "${RED}=====================================================${CLR}"
  echo
}

function body_section() {
  apt-get -y install openvpn easy-rsa
  systemctl stop openvpn
  systemctl disable openvpn

  cd /usr/share/easy-rsa
  ./easyrsa --batch init-pki
  ./easyrsa --batch build-ca nopass
  ./easyrsa --batch gen-dh
  ./easyrsa --batch build-server-full server nopass
  cd && cp -R /usr/share/easy-rsa/pki /etc/openvpn/

  [[ -d /etc/openvpn/server ]] && rm -d /etc/openvpn/server
  cat  >/etc/openvpn/server-tcp.conf <<-ENDTCP
port 1194
proto tcp
dev tun

ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem

server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 60
cipher AES-256-GCM
topology subnet
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/ovpn-tcp.log
verb 3
mute 20
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
ENDTCP

  echo "# ----------------------------
# OPENVPN BY $DOMAIN
# ----------------------------
setenv CLIENT_CERT 0
setenv FRIENDLY_NAME "$NAME VPN"
client
dev tun
proto tcp
remote $DOMAIN 1194
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
;http-proxy-retry
;http-proxy $IPADDR 3128
;http-proxy-option CUSTOM-HEADER Protocol HTTP/1.1
;http-proxy-option CUSTOM-HEADER Host $DOMAIN
mute-replay-warnings
remote-cert-tls server
cipher AES-256-GCM
comp-lzo
verb 3
mute 20
auth-user-pass" >/etc/openvpn/client/client-tcp.ovpn

  echo "" >>/etc/openvpn/client/client-tcp.ovpn
  echo "<ca>" >>/etc/openvpn/client/client-tcp.ovpn
  cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tcp.ovpn
  echo "</ca>" >>/etc/openvpn/client/client-tcp.ovpn
  cp /etc/openvpn/client/client-tcp.ovpn /var/www/html/client-tcp.ovpn

  cat >/etc/openvpn/server-tls.conf <<-ENDTLS
port 994
proto tcp
dev tun

ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem

server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
route $IPADDR 255.255.255.255 net_gateway
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 60
cipher AES-256-GCM
topology subnet
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
log /var/log/openvpn/ovpn-tls.log
verb 3
mute 20
verify-client-cert none
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
username-as-common-name
ENDTLS

  echo "# ----------------------------
# OPENVPN BY $DOMAIN
# ----------------------------
setenv CLIENT_CERT 0
setenv FRIENDLY_NAME "$NAME VPN"
client
dev tun
proto tcp
remote $DOMAIN 994
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
mute-replay-warnings
remote-cert-tls server
cipher AES-256-GCM
comp-lzo
verb 3
mute 20
auth-user-pass" >/etc/openvpn/client/client-tls.ovpn

  echo "" >>/etc/openvpn/client/client-tls.ovpn
  echo "<ca>" >>/etc/openvpn/client/client-tls.ovpn
  cat /etc/openvpn/pki/ca.crt >>/etc/openvpn/client/client-tls.ovpn
  echo "</ca>" >>/etc/openvpn/client/client-tls.ovpn
  cp /etc/openvpn/client/client-tls.ovpn /var/www/html/client-tls.ovpn

  systemctl enable openvpn@server-tcp
  systemctl enable openvpn@server-tls
}

function foot_section() {
  # delete openvpn script
  rm ~/openvpn.sh

  echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo -e "${YELLOW} Name${CLR}:${GREEN} openvpn.sh                                    ${CLR}"
  echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install openvpn automatic           ${CLR}"
  echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
  echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
  echo
}

function install_package() {
  check_root
  check_virtual
  check_distro
  head_section
  body_section
  foot_section
}
install_package