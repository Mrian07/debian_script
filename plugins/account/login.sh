#!/bin/bash

RED="\e[31;1m"
BLUE="\e[34;1m"
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

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
cat "/var/log/auth.log" | grep -i dropbear | grep -i "Password auth succeeded" >/tmp/dropbear-users-login.txt
cat /tmp/dropbear-users-login.txt | grep "dropbear\[$sid\]" >/tmp/dropbear-service-ids.txt
getUser=$(awk '{print $10}' /tmp/dropbear-service-ids.txt)
getAddr=$(awk '{print $12}' /tmp/dropbear-service-ids.txt)
getSid=($(ps aux | grep -i dropbear | awk '{print $2}'))
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