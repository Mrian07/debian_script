#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
    read -r -p "Masukkan nama pengguna: " getUser
    if grep -sw "$getUser" /etc/shadowsocks-libev/accounts; then
        echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
        read -r -p "Sila masukkan semula nama pengguna: " getUser
    fi
done

until [[ -n $getPass ]]; do
    read -r -p "Masukkan kata laluan: " getPass
done

getPort=$(awk '{print $2}' /etc/shadowsocks-libev/accounts)
if [[ $getPort = "" ]]; then
    newPort=8388
else
    newPort=$(( getPort + 1 ))
fi

until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
    read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

read -r -p "Masukkan OBFS (http|tls): " getObfs
if [[ -z $getObfs ]]; then
    getObfs="http"
fi

ss_uri=$(ss://aes-256-gcm:${getPass}@${DOMAIN}:${newPort}/?plugin=obfs-local;obfs=${getObfs};obfs-host=${DOMAIN})
user_info=$ss_uri#$getUser
echo "$IPADDR $newPort $getObfs $getUser $getPass $expDate" >>/etc/shadowsocks-libev/accounts

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}     IP/Domain${CLR}:${GREEN} $IPADDR / $DOMAIN${CLR}"
echo -e "${YELLOW}          port${CLR}:${GREEN} $newPort${CLR}"
echo -e "${YELLOW}       Encrypt${CLR}:${GREEN} aes-256-gcm${CLR}"
echo -e "${YELLOW}        Plugin${CLR}:${GREEN} simple-obfs${CLR}"
echo -e "${YELLOW}          Obfs${CLR}:${GREEN} $getObfs${CLR}"
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}   Kata laluan${CLR}:${GREEN} $getPass${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo "$user_info"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
