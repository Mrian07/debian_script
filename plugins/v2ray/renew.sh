#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo

read -r -p "Username : " getUser
if ! grep -qw "$getUser" /donb/v2ray/v2ray-clients.txt; then
	echo -e ""
	echo -e "User '$getUser' does not exist."
	echo -e ""
	exit 0
fi
read -r -p "Duration (day) : " getDuration

uuid=$(grep -w "$getUser" /donb/v2ray/v2ray-clients.txt | awk '{print $2}')
exp_old=$(grep -w "$getUser" /donb/v2ray/v2ray-clients.txt | awk '{print $3}')
diff=$((($(date -d "${exp_old}" +%s) - $(date +%s)) / (86400)))
duration=$((diff + getDuration + 1))
exp_new=$(date -d +"${duration}"days +%Y-%m-%d)
exp=$(date -d "${exp_new}" +"%d %b %Y")

sed -i "/\b$getUser\b/d" /donb/v2ray/v2ray-clients.txt
echo -e "$getUser\t$uuid\t$exp_new" >>/donb/v2ray/v2ray-clients.txt

clear
echo -e "V2Ray User Information"
echo -e "----------------------"
echo -e "Username : $getUser"
echo -e "Expired date : $exp"
echo -e ""

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo