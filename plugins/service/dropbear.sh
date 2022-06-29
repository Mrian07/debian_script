#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

function installPkg {
  while true; do
    read -p "Teruskan dengan pemasangan semula? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      if [[ ! -f /etc/default/dropbear ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh && bash dropbear.sh
      fi
      systemctl stop dropbear
      apt-get -y -qq purge --autoremove dropbear
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh && bash dropbear.sh
      ;;
    [Nn]) dropbearMenu ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -p "Anda pasti mahu menyahpasang dropbear? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop dropbear
      apt-get -y -qq purge --autoremove dropbear
      echo "Bersihkan & Keluarkan pakej dropbear" && exit 0
      ;;
    [Nn]) dropbearMenu ;;
    esac
  done
}

function configurePkg {
  getPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
  clear && echo
  echo "Secara lalai perkhidmatan dropbear mengunakan port $getPort"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPort
      if [[ ! -z $readPort && $readPort =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPort | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop dropbear
        sed -i "s|${getPort}|${readPort}|g" /etc/default/dropbear
        systemctl start dropbear
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn]) echo "Tiada perubahan dibuat" && break ;;
    esac
  done

  tlsPort=$(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"')
  clear && echo
  echo "Secara lalai dropbear menggunakan $tlsPort untuk sambungan stunnel"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPort
      if [[ ! -z $readPort && $readPort =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPort | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop dropbear
        sed -i "s|${tlsPort}|${readPort}|g" /etc/default/dropbear
        systemctl start dropbear
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn])
      dropbearMenu && break
      ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show dropbear.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show dropbear.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active dropbear.service)
  local isEnable=$(systemctl is-enabled dropbear.service)
  local defaultPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
  local stunnelPort=($(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"'))

  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "BUTIRAN PERKHIDMATAN DROPBEAR"
  echo -e "-----------------------------------------------------"
  echo -e "${YELLOW} Name    ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc    ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status  ${CLR}:${GREEN} $isActive \& $isEnable${CLR}"
  echo -e "${YELLOW} Ports   ${CLR}:${GREEN} $defaultPort (default) | $stunnelPort (stunnel)${CLR}"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
}

function dropbearMenu {
  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "MENU DROPBEAR"
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
    03 | configure) configurePkg && break ;;
    04 | detail) detailPkg && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) dropbearMenu ;;
    esac
  done
}

[[ -f /etc/default/dropbear ]] && dropbearMenu || installPkg