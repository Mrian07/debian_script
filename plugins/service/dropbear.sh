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

function install_package {
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
    [Nn]) dropbear_menu ;;
    esac
  done
}

function uninstall_package {
  while true; do
    read -p "Anda pasti mahu menyahpasang dropbear? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop dropbear
      apt-get -y -qq purge --autoremove dropbear
      echo "Bersihkan & Keluarkan pakej dropbear" && exit 0
      ;;
    [Nn]) dropbear_menu ;;
    esac
  done
}

function configure_package {
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
      dropbear_menu && break
      ;;
    esac
  done
}

function detail_package {
  local unitName=$(systemctl show dropbear.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show dropbear.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active dropbear.service)
  local isEnable=$(systemctl is-enabled dropbear.service)
  local defaultPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
  local stunnelPort=($(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"'))

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name    ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc    ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status  ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports   ${CLR}:${GREEN} $defaultPort (default) | $stunnelPort (stunnel)${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function dropbear_menu {
  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
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
    03 | configure) configure_package && break ;;
    04 | detail) detail_package && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) dropbear_menu ;;
    esac
  done
}

[[ -f /etc/default/dropbear ]] && dropbear_menu || install_package