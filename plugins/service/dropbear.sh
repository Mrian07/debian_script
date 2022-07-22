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

function install {
  while true; do
    read -r -p "Teruskan dengan pemasangan semula? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      if [[ ! -f /etc/default/dropbear ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh \
        && chmod +x dropbear.sh && ./dropbear.sh
      fi
      systemctl stop dropbear
      apt-get -y -qq purge --autoremove dropbear && sleep 3
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej dropbear... ${CLR}"
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh \
      && chmod +x dropbear.sh && ./dropbear.sh &>/dev/null
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -r -p "Anda pasti mahu menyahpasang dropbear? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop dropbear
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej dropbear... ${CLR}"
      apt-get -y -qq purge --auto-remove dropbear
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  tcpPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
  clear && echo
  echo -e "${MAGENTA}Secara lalai perkhidmatan dropbear mengunakan port${CLR} ${GREEN}$tcpPort${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortTCP
      if [[ ! -z $readPortTCP && $readPortTCP =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i :$readPortTCP | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -p "Masukkan semula port baharu: " readPortTCP
        fi

        systemctl stop dropbear
        sed -i "s|${tcpPort}|${readPortTCP}|g" /etc/default/dropbear
        systemctl start dropbear
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
    esac
  done

  tlsPort=$(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"')
  clear && echo
  echo -e "${MAGENTA}Secara lalai dropbear menggunakan${CLR} ${GREEN}$tlsPort${CLR} ${MAGENTA}untuk sambungan stunnel${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortTLS
      if [[ ! -z $readPortTLS && $readPortTLS =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i :$readPortTLS | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -p "Masukkan semula port baharu: " readPortTLS
        fi

        systemctl stop dropbear
        sed -i "s|${tlsPort}|${readPortTLS}|g" /etc/default/dropbear
        systemctl start dropbear
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function detail {
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

[[ -f /etc/default/dropbear ]] && _menu || install