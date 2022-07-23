#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

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

apt-get -y install stunnel4
systemctl stop stunnel4

[[ ! -d /etc/ssl/cybertize ]] && mkdir /etc/ssl/cybertize
openssl genrsa -out /etc/ssl/cybertize/key.pem 2048
openssl req -new -x509 -batch \
  -key /etc/ssl/cybertize/key.pem \
  -out /etc/ssl/cybertize/cert.pem -days 365
openssl dhparam 2048 >>/etc/ssl/cybertize/dh2048.pem

cat /etc/ssl/cybertize/key.pem >/etc/stunnel/stunnel.pem
cat /etc/ssl/cybertize/cert.pem >>/etc/stunnel/stunnel.pem
cat /etc/ssl/cybertize/dh2048.pem >>/etc/stunnel/stunnel.pem
chmod 600 /etc/stunnel/stunnel.pem

cat >/etc/stunnel/stunnel.conf <<-EOF
pid = /var/run/stunnel4.pid
log = append
output = /var/log/stunnel4/stunnel.log
cert = /etc/stunnel/stunnel.pem
client = no

socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear service]
accept = 2000
connect = 127.0.0.1:2020

[openvpn service]
accept = 2001
connect = 127.0.0.1:5000
EOF

echo 'ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
PPP_RESTART=0
RLIMITS="-n 4096"' >/etc/default/stunnel4

rm ~/stunnel.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} stunnel.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install stunnel automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
