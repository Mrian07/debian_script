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

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  if grep -sw "$getUser" /etc/shadowsocks-libev/.accounts; then
    echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
    read -p "Sila masukkan semula nama pengguna: " getUser
  fi
done

until [[ ! -z $getPass ]]; do
  read -p "Masukkan kata laluan: " getPass
done

getPort=$(cat /etc/shadowsocks-libev/.accounts | awk '{print $2}')
if [[ $getPort = "" ]]; then
  newPort=8388
else
  newPort=(( $getPort + 1 ))
fi

until [[ ! -z $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
  read -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

read -r -p "Masukkan OBFS (tls|http): " getObfs
if [[ -z $getObfs ]]; then
  getObfs="http"
fi

if [[ $getObfs = "http" ]]; then

elif [[ $getObfs = "tls" ]]; then

fi

ss_link=$(ss://aes-128-gcm:${getPass}@${DOMAIN}:${newPort}/?plugin=obfs-local;obfs=${getObfs};obfs-host=${DOMAIN} | base64)
ss_base64=$ss_link#$getUser
echo "$IPADDR $newPort $getObfs $getUser $expDate $getPass" >>/etc/shadowsocks-libev/.accounts

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
echo -e "${YELLOW} Nama hostname${CLR}:${GREEN} $DOMAIN${CLR}"
echo -e "${YELLOW}          Port${CLR}:${GREEN} $newPort${CLR}"
echo -e "${YELLOW}   Kata laluan${CLR}:${GREEN} $getPass${CLR}"
echo -e "${YELLOW}       Encrypt${CLR}:${GREEN} aes-256-gcm${CLR}"
echo -e "${YELLOW}        Plugin${CLR}:${GREEN} simple-obfs${CLR}"
echo -e "${YELLOW}          Obfs${CLR}:${GREEN} $getObfs${CLR}"
echo -e "${YELLOW}          Host${CLR}:${GREEN} ${DOMAIN}${CLR}"
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo "$ss_base64"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo