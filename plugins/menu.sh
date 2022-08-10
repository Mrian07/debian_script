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

clear && echo
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
echo -e "${BLUE}DROPBEAR & OPENVPN${CLR}"
echo -e " ${YELLOW}[01]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"
echo -e " ${YELLOW}[02]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"
echo -e " ${YELLOW}[03]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"
echo -e " ${YELLOW}[04]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"
echo -e " ${YELLOW}[05]${CLR} ➟ ${GREEN}Ganti kata laluan${CLR}"
echo -e " ${YELLOW}[06]${CLR} ➟ ${GREEN}Lock akaun${CLR}"
echo -e " ${YELLOW}[07]${CLR} ➟ ${GREEN}Unlock akaun${CLR}"
echo -e " ${YELLOW}[08]${CLR} ➟ ${GREEN}Padam akaun${CLR}"
echo
echo -e "${BLUE}SHADOWSOCKS${CLR}"
echo -e " ${YELLOW}[09]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"
echo -e " ${YELLOW}[10]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"
echo -e " ${YELLOW}[11]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"
echo -e " ${YELLOW}[12]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"
echo -e " ${YELLOW}[13]${CLR} ➟ ${GREEN}Padam akaun${CLR}"
echo
echo -e "${BLUE}V2RAY${CLR}"
echo -e " ${YELLOW}[14]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"
echo -e " ${YELLOW}[15]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"
echo -e " ${YELLOW}[16]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"
echo -e " ${YELLOW}[17]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"
echo -e " ${YELLOW}[18]${CLR} ➟ ${GREEN}Padam akaun${CLR}"
echo
echo -e "${BLUE}XRAY${CLR}"
echo -e " ${YELLOW}[19]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"
echo -e " ${YELLOW}[20]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"
echo -e " ${YELLOW}[21]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"
echo -e " ${YELLOW}[22]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"
echo -e " ${YELLOW}[23]${CLR} ➟ ${GREEN}Padam akaun${CLR}"
echo
echo -e "${BLUE}WIREGUARD${CLR}"
echo -e " ${YELLOW}[24]${CLR} ➟ ${GREEN}Tambah akaun${CLR}"
echo -e " ${YELLOW}[25]${CLR} ➟ ${GREEN}Perbaharui akaun${CLR}"
echo -e " ${YELLOW}[26]${CLR} ➟ ${GREEN}Senarai log masuk${CLR}"
echo -e " ${YELLOW}[27]${CLR} ➟ ${GREEN}Senarai akaun${CLR}"
echo -e " ${YELLOW}[28]${CLR} ➟ ${GREEN}Padam akaun${CLR}"
echo
echo -e "${BLUE}SERVICE${CLR}"
echo -e " ${YELLOW}[29]${CLR} ➟ ${GREEN}Menu Nginx${CLR}"
echo -e " ${YELLOW}[30]${CLR} ➟ ${GREEN}Menu Dropbear${CLR}"
echo -e " ${YELLOW}[31]${CLR} ➟ ${GREEN}Menu OpenVPN${CLR}"
echo -e " ${YELLOW}[32]${CLR} ➟ ${GREEN}Menu Shadowsocks${CLR}"
echo -e " ${YELLOW}[33]${CLR} ➟ ${GREEN}Menu V2ray${CLR}"
echo -e " ${YELLOW}[34]${CLR} ➟ ${GREEN}Menu Xray${CLR}"
echo -e " ${YELLOW}[35]${CLR} ➟ ${GREEN}Menu Wireguard${CLR}"
echo -e " ${YELLOW}[36]${CLR} ➟ ${GREEN}Menu Squid${CLR}"
echo -e " ${YELLOW}[37]${CLR} ➟ ${GREEN}Menu OHPServer${CLR}"
echo -e " ${YELLOW}[38]${CLR} ➟ ${GREEN}Menu WebSocket${CLR}"
echo -e " ${YELLOW}[39]${CLR} ➟ ${GREEN}Menu Stunnel${CLR}"
echo -e " ${YELLOW}[40]${CLR} ➟ ${GREEN}Menu BadVPN${CLR}"
echo
echo -e "${BLUE}SERVER${CLR}"
echo -e " ${YELLOW}[41]${CLR} ➟ ${GREEN}Details${CLR}"
echo -e " ${YELLOW}[42]${CLR} ➟ ${GREEN}Speedtest${CLR}"
echo -e " ${YELLOW}[43]${CLR} ➟ ${GREEN}Cloudflare${CLR}"
echo -e " ${YELLOW}[44]${CLR} ➟ ${GREEN}DigitalOcean${CLR}"
echo -e " ${YELLOW}[45]${CLR} ➟ ${GREEN}Backup${CLR}"
echo -e " ${YELLOW}[46]${CLR} ➟ ${GREEN}Restore${CLR}"
echo
echo -e " ${YELLOW}[00]${CLR} ➟ ${GREEN}Keluar dari menu${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo

read -r -p "Masukkan pilihan anda: " getChoice
case $getChoice in
  # dropbear & openvpn
  01) bash /usr/local/cybertize/plugins/acc-create.sh ;;
  02) bash /usr/local/cybertize/plugins/acc-renew.sh ;;
  03) bash /usr/local/cybertize/plugins/acc-login.sh ;;
  04) bash /usr/local/cybertize/plugins/acc-lists.sh ;;
  05) bash /usr/local/cybertize/plugins/acc-password.sh ;;
  06) bash /usr/local/cybertize/plugins/acc-lock.sh ;;
  07) bash /usr/local/cybertize/plugins/acc-unlock.sh ;;
  08) bash /usr/local/cybertize/plugins/acc-delete.sh ;;

  # shadowsocks
  09) bash /usr/local/cybertize/plugins/libev-create.sh ;;
  10) bash /usr/local/cybertize/plugins/libev-renew.sh ;;
  11) bash /usr/local/cybertize/plugins/libev-login.sh ;;
  12) bash /usr/local/cybertize/plugins/libev-lists.sh ;;
  13) bash /usr/local/cybertize/plugins/libev-delete.sh ;;

  # v2ray
  14) bash /usr/local/cybertize/plugins/v2ray-create.sh ;;
  15) bash /usr/local/cybertize/plugins/v2ray-renew.sh ;;
  16) bash /usr/local/cybertize/plugins/v2ray-login.sh ;;
  17) bash /usr/local/cybertize/plugins/v2ray-lists.sh ;;
  18) bash /usr/local/cybertize/plugins/v2ray-delete.sh ;;

  # xray
  19) bash /usr/local/cybertize/plugins/xray-create.sh ;;
  20) bash /usr/local/cybertize/plugins/xray-renew.sh ;;
  21) bash /usr/local/cybertize/plugins/xray-login.sh ;;
  22) bash /usr/local/cybertize/plugins/xray-lists.sh ;;
  23) bash /usr/local/cybertize/plugins/xray-delete.sh ;;

  # wireguard
  24) bash /usr/local/cybertize/plugins/wireguard-create.sh ;;
  25) bash /usr/local/cybertize/plugins/wireguard-renew.sh ;;
  26) bash /usr/local/cybertize/plugins/wireguard-login.sh ;;
  27) bash /usr/local/cybertize/plugins/wireguard-lists.sh ;;
  28) bash /usr/local/cybertize/plugins/wireguard-delete.sh ;;

  # service
  29) bash /usr/local/cybertize/plugins/service-nginx.sh ;;
  30) bash /usr/local/cybertize/plugins/service-dropbear.sh ;;
  31) bash /usr/local/cybertize/plugins/service-openvpn.sh ;;
  32) bash /usr/local/cybertize/plugins/service-libev.sh ;;
  33) bash /usr/local/cybertize/plugins/service-v2ray.sh ;;
  34) bash /usr/local/cybertize/plugins/service-xray.sh ;;
  35) bash /usr/local/cybertize/plugins/service-wireguard.sh ;;
  36) bash /usr/local/cybertize/plugins/service-squid.sh ;;
  37) bash /usr/local/cybertize/plugins/service-ohpserver.sh ;;
  38) bash /usr/local/cybertize/plugins/service-websocket.sh ;;
  39) bash /usr/local/cybertize/plugins/service-stunnel.sh ;;
  40) bash /usr/local/cybertize/plugins/service-badvpn.sh ;;

  # server
  41) bash /usr/local/cybertize/plugins/details.sh ;;
  42) speedtest ;;
  43) bash /usr/local/cybertize/plugins/cloudflare.sh ;;
  44) bash /usr/local/cybertize/plugins/digitalocean.sh ;;
  45) bash /usr/local/cybertize/plugins/backup.sh ;;
  46) bash /usr/local/cybertize/plugins/restore.sh ;;

  # other
  00) clear && exit 0 ;;
  *) menu ;;
esac