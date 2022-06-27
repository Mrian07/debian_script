#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

clear && echo
echo -e "${RED}=====================================================${CLR}"
echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo -e "${RED}=====================================================${CLR}"
echo

COUNTRY=$(grep -sw 'COUNTRY' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
STATE=$(grep -sw 'STATE' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
REGION=$(grep -sw 'REGION' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
ORG=$(grep -sw 'ORG' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
UNIT=$(grep -sw 'UNIT' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
NAME=$(grep -sw 'NAME' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')

apt-get -y install stunnel4
systemctl stop stunnel4

openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 365 \
  -subj "/C=$COUNTRY/ST=$STATE/L=$REGION/O=$ORG/OU=$UNIT/CN=$NAME"
cat ~/key.pem ~/cert.pem >/etc/stunnel/stunnel.pem
rm -f ~/key.pem && rm -f ~/cert.pem
openssl dhparam 2048 >>/etc/stunnel/stunnel.pem

cat >/etc/stunnel/stunnel.conf <<-EOF
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
connect = 127.0.0.1:994
EOF

echo 'ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
PPP_RESTART=0
RLIMITS="-n 4096"' >/etc/default/stunnel4

# delete stunnel script
rm ~/stunnel.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} stunnel.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install stunnel automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo