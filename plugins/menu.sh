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

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${BLUE}DROPBEAR${CLR}"
echo -e " ${YELLOW}[01]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"       # [O]
echo -e " ${YELLOW}[02]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"   # [O]
echo -e " ${YELLOW}[03]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"  # [O]
echo -e " ${YELLOW}[04]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"      # [O]
echo -e " ${YELLOW}[05]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"  # [O]
echo -e " ${YELLOW}[06]${CLR} ➟ ${GREEN}Lock akaun${CLR}"         # [O]
echo -e " ${YELLOW}[07]${CLR} ➟ ${GREEN}Unlock akaun${CLR}"       # [O]
echo -e " ${YELLOW}[08]${CLR} ➟ ${GREEN}Padam akaun${CLR}"        # [O]
echo
echo -e "${BLUE}OPENVPN${CLR}"
echo -e " ${YELLOW}[09]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"       # [O]
echo -e " ${YELLOW}[10]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"   # [O]
echo -e " ${YELLOW}[11]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"  # [O]
echo -e " ${YELLOW}[12]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"      # [O]
echo -e " ${YELLOW}[13]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"  # [O]
echo -e " ${YELLOW}[14]${CLR} ➟ ${GREEN}Lock akaun${CLR}"         # [O]
echo -e " ${YELLOW}[15]${CLR} ➟ ${GREEN}Unlock akaun${CLR}"       # [O]
echo -e " ${YELLOW}[16]${CLR} ➟ ${GREEN}Padam akaun${CLR}"        # [O]
echo
echo -e "${BLUE}SHADOWSOCKS${CLR}"
echo -e " ${YELLOW}[17]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"       # [O]
echo -e " ${YELLOW}[18]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"   # [O]
echo -e " ${YELLOW}[19]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"  # [O]
echo -e " ${YELLOW}[20]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"      # [O]
echo -e " ${YELLOW}[21]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"  # [O]
echo -e " ${YELLOW}[22]${CLR} ➟ ${GREEN}Nyadayakan akaun${CLR}"   # [O]
echo -e " ${YELLOW}[23]${CLR} ➟ ${GREEN}Dayakan akaun${CLR}"      # [O]
echo -e " ${YELLOW}[24]${CLR} ➟ ${GREEN}Padam akaun${CLR}"        # [O]
echo
echo -e "${BLUE}SERVICE${CLR}"
echo -e " ${YELLOW}[25]${CLR} ➟ ${GREEN}Menu Nginx${CLR}"         # [O]
echo -e " ${YELLOW}[26]${CLR} ➟ ${GREEN}Menu Dropbear${CLR}"      # [O]
echo -e " ${YELLOW}[27]${CLR} ➟ ${GREEN}Menu OpenVPN${CLR}"       # [O]
echo -e " ${YELLOW}[28]${CLR} ➟ ${GREEN}Menu Shadowsocks${CLR}"   # [O]
echo -e " ${YELLOW}[29]${CLR} ➟ ${GREEN}Menu Squid${CLR}"         # [O]
echo -e " ${YELLOW}[30]${CLR} ➟ ${GREEN}Menu Stunnel${CLR}"       # [O]
echo -e " ${YELLOW}[31]${CLR} ➟ ${GREEN}Menu BadVPN${CLR}"        # [O]

echo
echo -e "${BLUE}SERVER${CLR}"
echo -e " ${YELLOW}[32]${CLR} ➟ ${GREEN}Speedtest${CLR}"          # [O]
# echo -e " ${YELLOW}[33]${CLR} ➟ ${GREEN}TcpBBR${CLR}"             # [O]
# echo -e " ${YELLOW}[34]${CLR} ➟ ${GREEN}WonderShaper${CLR}"       # [O]
# echo -e " ${YELLOW}[35]${CLR} ➟ ${GREEN}Add Domain${CLR}"         # [X]
# echo -e " ${YELLOW}[36]${CLR} ➟ ${GREEN}Remove Domain${CLR}"      # [X]
# echo -e " ${YELLOW}[37]${CLR} ➟ ${GREEN}Backup${CLR}"             # [X]
# echo -e " ${YELLOW}[38]${CLR} ➟ ${GREEN}Restore${CLR}"            # [X]
echo
echo -e " ${YELLOW}[00]${CLR} ➟ ${GREEN}Keluar dari menu${CLR}"
echo
echo -e "${BLUE}SERVER${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo

read -p "Masukkan pilihan anda: " getChoice
case $getChoice in
  # dropbear
  01) ./usr/local/cybertize/plugins/dropbear/create.sh ;;
  02) ./usr/local/cybertize/plugins/dropbear/renew.sh ;;
  03) ./usr/local/cybertize/plugins/dropbear/login.sh ;;
  04) ./usr/local/cybertize/plugins/dropbear/lists.sh ;;
  05) ./usr/local/cybertize/plugins/dropbear/password.sh ;;
  06) ./usr/local/cybertize/plugins/dropbear/lock.sh ;;
  07) ./usr/local/cybertize/plugins/dropbear/unlock.sh ;;
  08) ./usr/local/cybertize/plugins/dropbear/delete.sh ;;

  # openvpn
  09) ./usr/local/cybertize/plugins/openvpn/create.sh ;;
  10) ./usr/local/cybertize/plugins/openvpn/renew.sh ;;
  11) ./usr/local/cybertize/plugins/openvpn/login.sh ;;
  12) ./usr/local/cybertize/plugins/openvpn/lists.sh ;;
  13) ./usr/local/cybertize/plugins/openvpn/password.sh ;;
  14) ./usr/local/cybertize/plugins/openvpn/lock.sh ;;
  15) ./usr/local/cybertize/plugins/openvpn/unlock.sh ;;
  16) ./usr/local/cybertize/plugins/openvpn/delete.sh ;;

  # shadowsocks
  17) ./usr/local/cybertize/plugins/shadowsocks/create.sh ;;
  18) ./usr/local/cybertize/plugins/shadowsocks/renew.sh ;;
  19) ./usr/local/cybertize/plugins/shadowsocks/login.sh ;;
  20) ./usr/local/cybertize/plugins/shadowsocks/lists.sh ;;
  21) ./usr/local/cybertize/plugins/shadowsocks/password.sh ;;
  22) ./usr/local/cybertize/plugins/shadowsocks/disable.sh ;;
  23) ./usr/local/cybertize/plugins/shadowsocks/enable.sh ;;
  24) ./usr/local/cybertize/plugins/shadowsocks/delete.sh ;;

  # service
  25) ./usr/local/cybertize/plugins/service/nginx.sh ;;
  26) ./usr/local/cybertize/plugins/service/dropbear.sh ;;
  27) ./usr/local/cybertize/plugins/service/openvpn.sh ;;
  28) ./usr/local/cybertize/plugins/service/Shadowsocks.sh ;;
  29) ./usr/local/cybertize/plugins/service/squid.sh ;;
  30) ./usr/local/cybertize/plugins/service/stunnel.sh ;;
  31) ./usr/local/cybertize/plugins/service/badvpn.sh ;;

  # server
  32) speedtest ;;

  # other
  00) clear && exit 0 ;;
  *) menu ;;
esac