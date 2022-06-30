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

function install_package {
  while true; do
    read -p "Teruskan dengan pemasangan semula? [Y/n] " readYesNo
    case $_readYesNo in
    [Yy])
      if [[ ! -f /usr/local/bin/badvpn-udpgw ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/badvpn.sh
        chmod +x badvpn.sh && ./badvpn.sh
      fi
      systemctl stop badvpn-udpgw
      systemctl disable badvpn-udpgw
      rm -f /usr/local/bin/badvpn-udpgw
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh
      chmod +x badvpn.sh && ./badvpn.sh
      ;;
    [Nn]) badvpn_menu && break ;;
    esac
  done
}

function uninstall_package {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang badvpn? [Y/n] " _readYesNo
    case $_readYesNo in
    [Yy])
      systemctl stop badvpn-udpgw
      systemctl disable badvpn-udpgw
      rm -f /usr/local/bin/badvpn-udpgw

      echo "Bersihkan & Keluarkan pakej badvpn" && exit 0
      ;;
    [Nn]) badvpn_menu && break ;;
    esac
  done
}

function detail_package {
  local unitName=$(systemctl show badvpn-udpgw.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show badvpn-udpgw.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active badvpn-udpgw.service)
  local isEnable=$(systemctl is-enabled badvpn-udpgw.service)
  local getPort=$(ps aux | grep 'badvpn-udpgw' | awk '{print $13}' | head -n 1 | cut -d : -f 2)

  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
  echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
  echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} $getPort${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function badvpn_menu {
  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
  echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
  echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} [01]${CLR} ${GREEN}reinstall ${CLR}- Pemasangan semula pakej"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}uninstall ${CLR}- Menyahpasang pakej"
  echo -e "${YELLOW} [04]${CLR} ${GREEN}detail    ${CLR}- Tunjukkan butiran & status"
  echo -e "${YELLOW} [05]${CLR} ${GREEN}back      ${CLR}- Kembali ke menu utama"
  echo -e "${YELLOW} [00]${CLR} ${GREEN}quit      ${CLR}- Keluar dari menu"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  while true; do
    read -p "Masukkan pilihan anda: " readChoice
    case "$readChoice" in
    01 | reinstall) install_package && break ;;
    02 | uninstall) uninstall_package && break ;;
    04 | detail) detail_package && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) badvpn_menu ;;
    esac
  done
}

[[ -f /usr/local/bin/badvpn-udpgw ]] && badvpn_menu || install_package