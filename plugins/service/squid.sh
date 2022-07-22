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
    read -r -p "Teruskan dengan pemasangan semula? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      if [[ ! -f /etc/squid/squid.conf ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh  \
        && chmod +x squid.sh && ./squid.sh
      fi
      systemctl stop squid
      apt-get -y purge --auto-remove squid && sleep 3
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej squid... ${CLR}"
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh  \
      && chmod +x squid.sh && ./squid.sh
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang squid? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej squid... ${CLR}"
      apt-get -y purge --auto-remove squid
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  getPorts=($(grep -w 'http_port' /etc/squid/squid.conf | cut -d ' ' -f 2,4))
  clear && echo
  echo -e "${MAGENTA}Secara lalai squid menggunakan${CLR} ${GREEN}${getPorts[0]}${CLR} ${MAGENTA}untuk sambungan${CLR}"
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

        systemctl stop squid
        sed -i "s@${getPorts[0]}@$readPort@g" /etc/squid/squid.conf
        systemctl start squid
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
    esac
  done

  getPortDropbear=$(grep 'ExecStart' /etc/systemd/system/ohpserver-dropbear.service | awk '{print $3}')
  getPortOpenvpn=$(grep 'ExecStart' /etc/systemd/system/ohpserver-openvpn.service | awk '{print $3}')
  clear && echo
  echo -e "${MAGENTA}Secara lalai squid menggunakan${CLR} ${GREEN}${getPorts[1]}${CLR} ${MAGENTA}untuk sambungan ohpserver${CLR}"
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

        systemctl stop squid
        systemctl stop ohpserver-dropbear
        systemctl stop ohpserver-openvpn
        sed -i "s@${getPorts[1]}@${readPort}@g" /etc/squid/squid.conf
        sed -i "s@${getPorts[1]}@${getPortDropbear}@g" /etc/systemd/system/ohpserver-dropbear.service
        sed -i "s@${getPorts[1]}@${getPortOpenvpn}@g" /etc/systemd/system/ohpserver-openvpn.service
        systemctl start squid
        systemctl start ohpserver-dropbear
        systemctl start ohpserver-openvpn
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function detail {
  local unitName=$(systemctl show squid.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show squid.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active squid.service)
  local isEnable=$(systemctl is-enabled squid.service)
  local getPort=($(grep -w 'http_port' /etc/squid/squid.conf | cut -d ' ' -f 2,4))

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} ${getPort[0]}(default) ${getPort[1]}(ohpserver)${CLR}"
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

[[ -f /etc/squid/squid.conf ]] && _menu || install