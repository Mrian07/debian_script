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

if [[ ! -d /etc/shadowsocks-libev/client ]]; then
  mkdir /etc/shadowsocks-libev/client
fi
if [[ ! -f /etc/shadowsocks-libev/.accounts ]]; then
  touch /etc/shadowsocks-libev/.accounts
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

until [[ ! -z $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
  read -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

until [[ ! -z $getObfs && $getObfs = "tls" || $getObfs = "http" ]]; do
  read -p "Masukkan OBFS (tls/http): " getObfs
  if [[ -z $getObfs ]]; then
    getObfs="tls"
  fi
done

getPort=$(cat /etc/shadowsocks-libev/.accounts | awk '{print $3}')
if [[ $getPort = "" ]]; then
  newPort=8388
else
  newPort=(( $getPort + 1 ))
fi

# port range 8388-8515 (127)
echo "{
    \"server\":\"0.0.0.0\",
    \"server_port\":8388,
    \"password\":\"$newPort\",
    \"method\":\"chacha20-ietf-poly1305\",
    \"mode\":\"tcp\",
    \"fast_open\":true,
    \"plugin\":\"obfs-server\",
    \"plugin_opts\":\"obfs=$getObfs\"
}" >/etc/shadowsocks-libev/$getUser-$getObfs.json

systemctl start shadowsocks-libev-server@$getUser-$getObfs
systemctl enable shadowsocks-libev-server@$getUser-$getObfs

echo "$DOMAIN $IPADDR $newPort $getObfs $getUser $expDate $getPass" >>/etc/shadowsocks-libev/.accounts

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
echo -e "${YELLOW}        Server${CLR}:${GREEN} $DOMAIN/$IPADDR${CLR}"
echo -e "${YELLOW}          Port${CLR}:${GREEN} $newPort${CLR}"
echo -e "${YELLOW}   Kata laluan${CLR}:${GREEN} $getPass${CLR}"
echo -e "${YELLOW}       Encrypt${CLR}:${GREEN} chacha20-ietf-poly1305${CLR}"
echo -e "${YELLOW}        Plugin${CLR}:${GREEN} simple-obfs${CLR}"
echo -e "${YELLOW}          Obfs${CLR}:${GREEN} $getObfs${CLR}"
echo -e "${YELLOW}          Host${CLR}:${GREEN} www.example.com${CLR}"
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo