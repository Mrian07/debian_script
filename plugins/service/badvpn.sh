#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

function installPkg {
  while true; do
    read -p "Teruskan dengan pemasangan semula? [Y/n] " readYesNo
    case $_readYesNo in
    [Yy])
      if [[ ! -f /usr/local/bin/badvpn-udpgw ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/badvpn.sh \
        && chmod +x badvpn.sh && ./badvpn.sh
      fi
      systemctl stop badvpn-udpgw
      systemctl disable badvpn-udpgw
      rm -f /usr/local/bin/badvpn-udpgw
      wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/squid.sh \
      && chmod +x badvpn.sh && ./badvpn.sh
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
  echo "==========================================="
  echo "BUTIRAN PERKHIDMATAN SQUID"
  echo "-------------------------------------------"
  echo " Name   : $unitName"
  echo " Desc   : $unitDesc"
  echo " Status : $isActive & $isEnable"
  echo " Ports  : $getPort"
  echo "-------------------------------------------"
  echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
  echo "==========================================="
  echo
}

function badvpnMenu {
  clear && echo
  echo "==========================================="
  echo "MENU SQUID"
  echo "-------------------------------------------"
  echo " [01] reinstall - Pemasangan semula pakej"
  echo " [02] uninstall - Menyahpasang pakej"
  echo " [04] detail    - Tunjukkan butiran & status"
  echo " [05] back      - Kembali ke menu utama"
  echo " [00] quit      - Keluar dari menu"
  echo "-------------------------------------------"
  echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
  echo "==========================================="
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