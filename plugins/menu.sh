#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

function check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
  fi
}

function check_virtual() {
  if [ -f /proc/user_beancounters ]; then
    echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
  fi
}

function check_distro() {
  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
  else
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}

check_root
check_virtual
check_distro

clear && echo
echo -e "${RED}=====================================================${CLR}"
echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo -e "${RED}=====================================================${CLR}"
echo
echo -e " ${YELLOW}[01]${CLR} ➟ ${GREEN}Tambah akaun pengguna${CLR}"
echo -e " ${YELLOW}[02]${CLR} ➟ ${GREEN}Perbaharui akaun pengguna${CLR}"
echo -e " ${YELLOW}[03]${CLR} ➟ ${GREEN}Senarai pengguna log masuk${CLR}"
echo -e " ${YELLOW}[04]${CLR} ➟ ${GREEN}Senaraikan semua pengguna${CLR}"
echo -e " ${YELLOW}[05]${CLR} ➟ ${GREEN}Ganti kata laluan pengguna${CLR}"
echo -e " ${YELLOW}[06]${CLR} ➟ ${GREEN}Nyadayakan akaun pengguna${CLR}"
echo -e " ${YELLOW}[07]${CLR} ➟ ${GREEN}Dayakan akaun pengguna${CLR}"
echo -e " ${YELLOW}[08]${CLR} ➟ ${GREEN}Padam akaun pengguna${CLR}"
echo
echo -e " ${YELLOW}[09]${CLR} ➟ ${GREEN}Menu perkhidmatan Nginx${CLR}"
echo -e " ${YELLOW}[10]${CLR} ➟ ${GREEN}Menu perkhidmatan Dropbear${CLR}"
echo -e " ${YELLOW}[11]${CLR} ➟ ${GREEN}Menu perkhidmatan OpenVPN${CLR}"
echo -e " ${YELLOW}[12]${CLR} ➟ ${GREEN}Menu perkhidmatan Squid${CLR}"
echo -e " ${YELLOW}[13]${CLR} ➟ ${GREEN}Menu perkhidmatan Stunnel${CLR}"
echo -e " ${YELLOW}[14]${CLR} ➟ ${GREEN}Menu perkhidmatan BadVPN${CLR}"
echo -e " ${YELLOW}[15]${CLR} ➟ ${GREEN}Uji kelajuan pelayan${CLR}"
echo -e " ${YELLOW}[00]${CLR} ➟ ${GREEN}Keluar dari menu${CLR}"
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo

read -p "Masukkan pilihan anda: " getChoice
case $getChoice in
  01) bash /usr/local/cybertize/plugins/account/create.sh ;;
  02) bash /usr/local/cybertize/plugins/account/renew.sh ;;
  03) bash /usr/local/cybertize/plugins/account/login.sh ;;
  04) bash /usr/local/cybertize/plugins/account/lists.sh ;;
  05) bash /usr/local/cybertize/plugins/account/password.sh ;;
  06) bash /usr/local/cybertize/plugins/account/lock.sh ;;
  07) bash /usr/local/cybertize/plugins/account/unlock.sh ;;
  08) bash /usr/local/cybertize/plugins/account/delete.sh ;;
  09) bash /usr/local/cybertize/plugins/service/nginx.sh ;;
  10) bash /usr/local/cybertize/plugins/service/dropbear.sh ;;
  11) bash /usr/local/cybertize/plugins/service/openvpn.sh ;;
  12) bash /usr/local/cybertize/plugins/service/squid.sh ;;
  13) bash /usr/local/cybertize/plugins/service/stunnel.sh ;;
  14) bash /usr/local/cybertize/plugins/service/badvpn.sh ;;
  15) speedtest ;;
  00) clear && exit 0 ;;
  *) menu ;;
esac