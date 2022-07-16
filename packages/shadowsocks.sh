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

apt-get -y install rng-tools
echo "HRNGDEVICE=/dev/urandom" >>/etc/default/rng-tools
systemctl restart rng-tools &>/dev/null
apt-get -y install netcat netcat-openbsd
apt-get -y install pwgen qrencode
apt-get -y install shadowsocks-libev
apt-get -y install simple-obfs
systemctl stop shadowsocks-libev
systemctl disable shadowsocks-libev

if [[ ! -f /etc/shadowsocks-libev/.accounts ]]; then
  touch /etc/shadowsocks-libev/.accounts
fi
rm ~/shadowsocks.sh

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} shadowsocks.sh                                ${CLR}"
echo -e "${YELLOW} Packs${CLR}:${GREEN} shadowsocks-libev, simple-obfs, haproxy       ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install shadowsocks automatic       ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 5