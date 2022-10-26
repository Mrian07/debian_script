#!/bin/bash

RED="\e[31;1m"
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
grep -i "Password auth succeeded" /var/log/auth.log >/tmp/dropbear-users-login.txt
grep "dropbear\[*\]" /tmp/dropbear-users-login.txt >/tmp/dropbear-service-ids.txt
getUser=$(awk '{print $10}' /tmp/dropbear-service-ids.txt)
getAddr=$(awk '{print $12}' /tmp/dropbear-service-ids.txt)
getSid=("$(pgrep aux | grep -i dropbear | awk '{print $2}')")
if [[ "${#getSid[@]}" -gt 0 ]]; then
    echo "$sid $getUser $getAddr"
fi
echo
echo -e "${WHITE}=====================================================${CLR}"
echo
if [ -f "/var/log/openvpn/status.log" ]; then
    grep -w "^CLIENT_LIST" /var/log/openvpn/status.log | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' >/tmp/ovpn-login-lists.txt
fi
cat /tmp/ovpn-login-lists.txt
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo