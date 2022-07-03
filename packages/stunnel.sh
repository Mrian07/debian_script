#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

COUNTRY=$(grep -sw 'COUNTRY' /usr/local/cybertize/.environment | cut -d '=' -f 2)
STATE=$(grep -sw 'STATE' /usr/local/cybertize/.environment | cut -d '=' -f 2)
REGION=$(grep -sw 'REGION' /usr/local/cybertize/.environment | cut -d '=' -f 2)
ORG=$(grep -sw 'ORG' /usr/local/cybertize/.environment | cut -d '=' -f 2)
UNIT=$(grep -sw 'UNIT' /usr/local/cybertize/.environment | cut -d '=' -f 2)
NAME=$(grep -sw 'NAME' /usr/local/cybertize/.environment | cut -d '=' -f 2)

[[ -e /etc/os-release ]] && source /etc/os-release

function head() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
  fi

  if [ -f /proc/user_beancounters ]; then
    echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
  fi

  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
  else
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}

function body() {
  apt-get -y install stunnel4
  systemctl stop stunnel4

  openssl genrsa -out key.pem 2048
  openssl req -new -x509 -key key.pem -out cert.pem -days 365 \
  -subj "/C=$COUNTRY/ST=$STATE/L=$REGION/O=$ORG/OU=$UNIT/CN=$NAME"
  cat key.pem >/etc/stunnel/stunnel.pem
  cat cert.pem >>/etc/stunnel/stunnel.pem
  openssl dhparam 2048 >>/etc/stunnel/stunnel.pem
  rm key.pem && rm cert.pem

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
}

function foot() {
  # delete stunnel script
  rm ~/stunnel.sh

  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
  echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
  echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} Name${CLR}:${GREEN} stunnel.sh                                    ${CLR}"
  echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install stunnel automatic           ${CLR}"
  echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function install_package() {
  head
  body
  foot
}
install_package
