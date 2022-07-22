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

function install {
  while true; do
    read -p "Teruskan dengan pemasangan semula? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      if [[ ! -f /etc/stunnel/stunnel.conf ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh \
        && chmod +x stunnel.sh && ./stunnel.sh
      fi
      systemctl stop stunnel4
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej stunnel... ${CLR}"
      apt-get -y purge --auto-remove stunnel*
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh \
      && chmod +x stunnel.sh && ./stunnel.sh
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -p "Adakah anda pasti mahu menyahpasang stunnel? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      systemctl stop stunnel4
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej squid... ${CLR}"
      apt-get -y purge --auto-remove stunnel*
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  getPorts=($(grep -w 'accept =' /etc/stunnel/stunnel.conf | cut -d '=' -f 2))
  clear && echo
  echo -e "${MAGENTA}Secara lalai stunnel menggunakan${CLR} ${GREEN}${getPorts[0]}${CLR} ${MAGENTA}untuk sambungan dropbear${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPort
      if [[ ! -z $readPort && $readPort =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPort | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop stunnel4
        sed -i "s@${getPorts[0]}@$readPort@g" /etc/stunnel/stunnel.conf
        systemctl start stunnel4
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
    esac
  done

  clear && echo
  echo -e "${MAGENTA}Secara lalai stunnel menggunakan${CLR} ${GREEN}${getPorts[1]}${CLR} ${MAGENTA}untuk sambungan openvpn${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -r -p "Masukkan port baharu: " readPort
      if [[ ! -z $readPort && $readPort =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPort | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -r -p "Masukkan semula port baharu: " readPort
        fi

        systemctl stop stunnel4
        sed -i "s@${getPorts[1]}@${readPort}@g" /etc/stunnel/stunnel.conf
        systemctl start stunnel4
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function detail {
  local unitName=$(systemctl show stunnel4.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show stunnel4.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active stunnel4.service)
  local isEnable=$(systemctl is-enabled stunnel4.service)
  local getPort=($(grep -w 'accept =' /etc/stunnel/stunnel.conf | cut -d '=' -f 2))

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} ${getPort[0]}(dropbear) | ${getPort[1]}(openvpn)${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function _menu {
  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} [01]${CLR} ${GREEN}reinstall ${CLR}- Pemasangan semula pakej"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}uninstall ${CLR}- Menyahpasang pakej"
  echo -e "${YELLOW} [03]${CLR} ${GREEN}configure ${CLR}- Edit fail configurasi"
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
    01 | reinstall) install && break ;;
    02 | uninstall) uninstall && break ;;
    03 | configure) configure && break ;;
    04 | detail) detail && break ;;
    05 | back) _menu && break ;;
    00 | quit) exit 0 ;;
    *) _menu ;;
    esac
  done
}

[[ -f /etc/stunnel/stunnel.conf ]] && _menu || install