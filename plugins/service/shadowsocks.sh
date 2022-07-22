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
      if [[ ! -d /etc/shadowsocks-libev ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/shadowsocks.sh \
        && chmod u+x shadowsocks && ./shadowsocks.sh
      fi
      systemctl stop shadowsocks-libev
      apt-get -y purge --auto-remove shadowsocks-libev && sleep 3
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej shadowsocks-libev... ${CLR}"
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/shadowsocks.sh \
      && chmod u+x shadowsocks && ./shadowsocks.sh
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang shadowsocks-libev? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej shadowsocks-libev... ${CLR}"
      systemctl stop shadowsocks-http.service
      systemctl stop shadowsocks-tls.service
      apt-get -y purge --auto-remove shadowsocks-libev
      rm -f /etc/systemd/system/shadowsocks-http.service
      rm -f /etc/systemd/system/shadowsocks-tls.service
      rm -r -f /etc/shadowsocks-libev
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Each client using different port, so we can't modified ${CLR}"
  echo -e "${YELLOW} port directly from this menu option, do change ${CLR}"
  echo -e "${YELLOW} port from sahdowsocks-libev config file. ${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo && exit 0
}

function detail {
  local unitName=$(systemctl show shadowsocks-libev.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show shadowsocks-libev.service -p Description | cut -d '=' -f 2)
  local isActiveTCP=$(systemctl is-active shadowsocks-http.service)
  local isEnableTCP=$(systemctl is-enabled shadowsocks-http.service)
  local isActiveTLS=$(systemctl is-active shadowsocks-tls.service)
  local isEnableTLS=$(systemctl is-enabled shadowsocks-tls.service)
  local getPorts=$(cat /etc/shadowsocks-libev/.accounts | awk '{print $2}' | wc -l)

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name          ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc          ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status (HTTP) ${CLR}:${GREEN} $isActiveTCP & $isEnableTCP${CLR}"
  echo -e "${YELLOW} Status (TLS)  ${CLR}:${GREEN} $isActiveTLS & $isEnableTLS${CLR}"
  echo -e "${YELLOW} Port lists    ${CLR}:${GREEN} $getPorts digunakan${CLR}"
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

[[ -d /etc/shadowsocks-libev ]] && _menu || install