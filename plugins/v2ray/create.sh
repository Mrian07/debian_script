#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
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

until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -r -p "Masukkan nama pengguna: " getUser
  if grep -sw "$getUser" /user/local/etc/v2ray/accounts &>/dev/null; then
    echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
    read -r -p "Sila masukkan semula nama pengguna: " getUser
  fi
done

until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
  read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASSWORD=$(uuidgen)
EMAIL=${getUser}@${DOMAIN}

echo "${getUser} ${PASSWORD} ${expDate}" >>/user/local/etc/v2ray/accounts

cat /usr/local/etc/v2ray/trojan-tcp-tls.json | jq '.inbounds[0].settings.clients += [{"password": "'${PASSWORD}'","email": "'${EMAIL}'"}]' >/usr/local/etc/v2ray/trojan-tcp-tls_tmp.json
mv -f /usr/local/etc/v2ray/trojan-tcp-tls_tmp.json /usr/local/etc/v2ray/trojan-tcp-tls.json
systemctl restart v2ray@trojan-tcp-tls

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
echo -e "${YELLOW}   Alamat emel${CLR}:${GREEN} $EMAIL${CLR}"
echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
