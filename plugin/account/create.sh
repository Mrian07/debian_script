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
    if grep -sw "$getUser" /etc/passwd &>/dev/null; then
        echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
        read -r -p "Sila masukkan semula nama pengguna: " getUser
    fi
done

until [[ -n $getPass ]]; do
    read -r -p "Masukkan kata laluan: " getPass
done

until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
    read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

useradd "$getUser"
usermod -c "client" "$getUser"
usermod -s /bin/false "$getUser"
usermod -e "$expDate" "$getUser"
echo -e "$getPass\n$getPass" | passwd "$getUser" &>/dev/null

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}   Kata laluan${CLR}:${GREEN} $getPass${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo