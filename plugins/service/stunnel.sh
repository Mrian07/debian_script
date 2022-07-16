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
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

function install_package {
  while true; do
    read -p "Teruskan dengan pemasangan semula? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      if [[ ! -f /etc/stunnel/stunnel.conf ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh && bash stunnel.sh
      fi
      systemctl stop stunnel4
      apt-get -y purge --autoremove stunnel*
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh && bash stunnel.sh
      ;;
    [Nn]) stunnel_menu && break ;;
    esac
  done
}

function uninstall_package {
  while true; do
    read -p "Adakah anda pasti mahu menyahpasang stunnel? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      systemctl stop stunnel
      apt-get -y purge --autoremove stunnel*
      echo "Bersihkan & Keluarkan pakej stunnel" && exit 0
      ;;
    [Nn]) stunnel_menu && break ;;
    esac
  done
}

function configure_package {
  getPorts=($(grep -w 'accept =' /etc/stunnel/stunnel.conf | cut -d '=' -f 2))
  clear && echo
  echo "Secara lalai perkhidmatan stunnel menggunakan 2 ports"
  echo "untuk dropbear dan openvpn."
  echo "NOTA: Jika anda ingin gantikan lebih dari satu port,"
  echo "anda perlu pisahkan dengan jarak. Contoh: $getPorts"
  while true; do
    read -p "Adakah anda mahu menukar port? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      read -p "Masukkan port baharu: " -a readPorts
      if [[ ! -z ${readPorts[0]} && ${readPorts[0]} =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:${readPorts[0]} | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop stunnel4
        sed -i "s|${getPorts[0]}|${readPorts[0]}|g" /etc/stunnel/stunnel.conf
        systemctl start stunnel4
      fi

      if [[ ! -z ${readPorts[1]} && ${readPorts[1]} =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:${readPorts[1]} | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop stunnel4
        sed -i "s|${getPorts[1]}|${readPorts[1]}|g" /etc/stunnel/stunnel.conf
        systemctl start stunnel4
      fi
      echo "Perubahan telah dibuat" && break
      ;;
    [Nn]) stunnel_menu && break ;;
    esac
  done
}

function detail_package {
  local unitName=$(systemctl show stunnel4.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show stunnel4.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active stunnel4.service)
  local isEnable=$(systemctl is-enabled stunnel4.service)
  local getPorts=($(grep -w 'accept =' /etc/stunnel/stunnel.conf | cut -d '=' -f 2))

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} ${getPorts[0]}(dropbear) | ${getPorts[1]}(openvpn)${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function stunnel_menu {
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
    *) stunnel_menu ;;
    esac
  done
}

[[ -f /etc/stunnel/stunnel.conf ]] && stunnel_menu || install_package