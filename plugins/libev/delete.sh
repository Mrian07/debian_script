#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
    getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
    if [[ $getVersion -ne 10 ]]; then
        echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
else
    echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

if [[ -f /etc/shadowsocks-libev/accounts ]]; then
    until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if ! grep -sw "$getUser" /etc/shadowsocks-libev/accounts; then
            echo -e "${RED}Nama pengguna tidak wujud!${CLR}"
            read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
    done
fi

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${GREEN} Akaun pengguna \"$getUser\" telah di padam ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
