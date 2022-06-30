#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

function head() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
  fi

  if [ -f /proc/user_beancounters ]; then
    echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
  fi

  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
  else
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}
head

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
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
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
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