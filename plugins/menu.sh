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
echo
echo -e "${BLUE}DROPBEAR & OPENVPN${CLR}"
echo -e " ${YELLOW}[01]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"       # [O]
echo -e " ${YELLOW}[02]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"   # [O]
echo -e " ${YELLOW}[03]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"  # [O]
echo -e " ${YELLOW}[04]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"      # [O]
echo -e " ${YELLOW}[05]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"  # [O]
echo -e " ${YELLOW}[06]${CLR} ➟ ${GREEN}Lock akaun${CLR}"         # [O]
echo -e " ${YELLOW}[07]${CLR} ➟ ${GREEN}Unlock akaun${CLR}"       # [O]
echo -e " ${YELLOW}[08]${CLR} ➟ ${GREEN}Padam akaun${CLR}"        # [O]
echo
echo -e "${BLUE}SHADOWSOCKS${CLR}"
echo -e " ${YELLOW}[09]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"       # [O]
echo -e " ${YELLOW}[10]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"   # [O]
echo -e " ${YELLOW}[11]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"  # [O]
echo -e " ${YELLOW}[12]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"      # [O]
echo -e " ${YELLOW}[13]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"  # [O]
echo -e " ${YELLOW}[14]${CLR} ➟ ${GREEN}Nyadayakan akaun${CLR}"   # [O]
echo -e " ${YELLOW}[15]${CLR} ➟ ${GREEN}Dayakan akaun${CLR}"      # [O]
echo -e " ${YELLOW}[16]${CLR} ➟ ${GREEN}Padam akaun${CLR}"        # [O]
echo
echo -e "${BLUE}SERVICE${CLR}"
echo -e " ${YELLOW}[17]${CLR} ➟ ${GREEN}Menu Nginx${CLR}"         # [O]
echo -e " ${YELLOW}[18]${CLR} ➟ ${GREEN}Menu Dropbear${CLR}"      # [O]
echo -e " ${YELLOW}[19]${CLR} ➟ ${GREEN}Menu OpenVPN${CLR}"       # [O]
echo -e " ${YELLOW}[20]${CLR} ➟ ${GREEN}Menu Shadowsocks${CLR}"   # [O]
echo -e " ${YELLOW}[21]${CLR} ➟ ${GREEN}Menu Squid${CLR}"         # [O]
echo -e " ${YELLOW}[22]${CLR} ➟ ${GREEN}Menu OHPServer${CLR}"     # [O]
echo -e " ${YELLOW}[23]${CLR} ➟ ${GREEN}Menu Stunnel${CLR}"       # [O]
echo -e " ${YELLOW}[24]${CLR} ➟ ${GREEN}Menu BadVPN${CLR}"        # [O]

echo
echo -e "${BLUE}SERVER${CLR}"
echo -e " ${YELLOW}[25]${CLR} ➟ ${GREEN}Speedtest${CLR}"          # [O]
# echo -e " ${YELLOW}[33]${CLR} ➟ ${GREEN}TcpBBR${CLR}"             # [O]
# echo -e " ${YELLOW}[34]${CLR} ➟ ${GREEN}WonderShaper${CLR}"       # [O]
# echo -e " ${YELLOW}[35]${CLR} ➟ ${GREEN}Add Domain${CLR}"         # [X]
# echo -e " ${YELLOW}[36]${CLR} ➟ ${GREEN}Remove Domain${CLR}"      # [X]
# echo -e " ${YELLOW}[37]${CLR} ➟ ${GREEN}Backup${CLR}"             # [X]
# echo -e " ${YELLOW}[38]${CLR} ➟ ${GREEN}Restore${CLR}"            # [X]
echo
echo -e " ${YELLOW}[00]${CLR} ➟ ${GREEN}Keluar dari menu${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo

read -p "Masukkan pilihan anda: " getChoice
case $getChoice in
  # dropbear & openvpn
  01) bash /usr/local/cybertize/plugins/account/create.sh ;;
  02) bash /usr/local/cybertize/plugins/account/renew.sh ;;
  03) bash /usr/local/cybertize/plugins/account/login.sh ;;
  04) bash /usr/local/cybertize/plugins/account/lists.sh ;;
  05) bash /usr/local/cybertize/plugins/account/password.sh ;;
  06) bash /usr/local/cybertize/plugins/account/lock.sh ;;
  07) bash /usr/local/cybertize/plugins/account/unlock.sh ;;
  08) bash /usr/local/cybertize/plugins/account/delete.sh ;;

  # shadowsocks
  09) bash /usr/local/cybertize/plugins/shadowsocks/create.sh ;;
  10) bash /usr/local/cybertize/plugins/shadowsocks/renew.sh ;;
  11) bash /usr/local/cybertize/plugins/shadowsocks/login.sh ;;
  12) bash /usr/local/cybertize/plugins/shadowsocks/lists.sh ;;
  13) bash /usr/local/cybertize/plugins/shadowsocks/password.sh ;;
  14) bash /usr/local/cybertize/plugins/shadowsocks/disable.sh ;;
  15) bash /usr/local/cybertize/plugins/shadowsocks/enable.sh ;;
  16) bash /usr/local/cybertize/plugins/shadowsocks/delete.sh ;;

  # service
  17) bash /usr/local/cybertize/plugins/service/nginx.sh ;;
  18) bash /usr/local/cybertize/plugins/service/dropbear.sh ;;
  19) bash /usr/local/cybertize/plugins/service/openvpn.sh ;;
  20) bash /usr/local/cybertize/plugins/service/Shadowsocks.sh ;;
  21) bash /usr/local/cybertize/plugins/service/squid.sh ;;
  22) bash /usr/local/cybertize/plugins/service/ohpserver.sh ;;
  23) bash /usr/local/cybertize/plugins/service/stunnel.sh ;;
  24) bash /usr/local/cybertize/plugins/service/badvpn.sh ;;

  # server
  25) speedtest ;;

  # other
  00) clear && exit 0 ;;
  *) menu ;;
esac
