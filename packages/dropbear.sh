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

export DEBIAN_FRONTEND=noninteractive
apt-get -y install cryptsetup cryptsetup-initramfs libtomcrypt1
apt-get -y install dropbear
systemctl stop dropbear

cp /etc/default/dropbear /etc/default/dropbear.old
echo 'NO_START=0
DROPBEAR_PORT=1153
DROPBEAR_EXTRA_ARGS="-p 1359 -p 1638"
DROPBEAR_BANNER="/etc/issue.net"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536' >/etc/default/dropbear

rm ~/dropbear.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} dropbear.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install dropbear automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3