#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

function installPkg {
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
    [Nn]) badvpnMenu && break ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang badvpn? [Y/n] " _readYesNo
    case $_readYesNo in
    [Yy])
      systemctl stop badvpn-udpgw
      systemctl disable badvpn-udpgw
      rm -f /usr/local/bin/badvpn-udpgw

      echo "Bersihkan & Keluarkan pakej badvpn" && exit 0
      ;;
    [Nn]) badvpnMenu && break ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show badvpn-udpgw.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show badvpn-udpgw.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active badvpn-udpgw.service)
  local isEnable=$(systemctl is-enabled badvpn-udpgw.service)
  local getPort=$(ps aux | grep 'badvpn-udpgw' | awk '{print $13}' | head -n 1 | cut -d : -f 2)

  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo -e "BUTIRAN PERKHIDMATAN SQUID"
  echo -e "-----------------------------------------------------"
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive \& $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} $getPort${CLR}"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
}

function badvpnMenu {
  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "MENU BADVPN"
  echo -e "-----------------------------------------------------"
  echo -e "${YELLOW} [01]${CLR} ${GREEN}reinstall ${CLR}- Pemasangan semula pakej"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}uninstall ${CLR}- Menyahpasang pakej"
  echo -e "${YELLOW} [04]${CLR} ${GREEN}detail    ${CLR}- Tunjukkan butiran & status"
  echo -e "${YELLOW} [05]${CLR} ${GREEN}back      ${CLR}- Kembali ke menu utama"
  echo -e "${YELLOW} [00]${CLR} ${GREEN}quit      ${CLR}- Keluar dari menu"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
  while true; do
    read -p "Masukkan pilihan anda: " readChoice
    case "$readChoice" in
    01 | reinstall) installPkg && break ;;
    02 | uninstall) uninstallPkg && break ;;
    04 | detail) detailPkg && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) badvpnMenu ;;
    esac
  done
}

[[ -f /usr/local/bin/badvpn-udpgw ]] && badvpnMenu || installPkg