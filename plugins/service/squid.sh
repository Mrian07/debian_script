#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

function installPkg {
  while true; do
    read -p "Teruskan dengan pemasangan semula? [Y/n] " readYesNo
    case $_readYesNo in
    [Yy])
      if [[ ! -d /etc/squid ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh && bash squid.sh
      fi
      apt-get -y purge --autoremove squid
      apt-get -qq autoclean
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh && bash squid.sh
      ;;
    [Nn]) squidMenu && break ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang squid? [Y/n] " _readYesNo
    case $_readYesNo in
    [Yy])
      apt-get -y -qq --purge remove squid
      apt-get -qq autoremove
      apt-get -qq autoclean

      echo "Bersihkan & Keluarkan pakej squid" && exit 0
      ;;
    [Nn]) squidMenu && break ;;
    esac
  done
}

function configurePkg {
  getPort=$(grep -w 'http_port' /etc/squid/squid.conf | cut -d ' ' -f 2)
  clear && echo
  echo "Secara lalai squid menggunakan port $getPort"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readYesNo
    case $readYesNo in
    [Yy])
      read -p "Masukkan port baharu: " readPort
      if [[ ! -z $readPort && $readPort =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPort | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop squid
        sed -i "s|$getPort|$readPort|g" /etc/squid/squid.conf
        systemctl start squid
      fi
      echo "Perubahan telah dibuat" && break
      ;;
    [Nn]) squidMenu && break ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show squid.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show squid.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active squid.service)
  local isEnable=$(systemctl is-enabled squid.service)
  local getPort=$(cat /etc/squid/squid.conf | grep -w 'http_port' | cut -d ' ' -f 2,4,6 | tr '\n' ' ')

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

function squidMenu {
  clear && echo
  echo "==========================================="
  echo "MENU SQUID"
  echo "-------------------------------------------"
  echo " [01] reinstall - Pemasangan semula pakej"
  echo " [02] uninstall - Menyahpasang pakej"
  echo " [03] configure - Edit fail konfigurasi"
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
    03 | configure) configurePkg && break ;;
    04 | detail) detailPkg && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) squidMenu ;;
    esac
  done
}

[[ -f /etc/squid/squid.conf ]] && squidMenu || installPkg