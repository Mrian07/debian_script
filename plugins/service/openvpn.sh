#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
  getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  if [[ $getVersion -ne 10 ]]; then
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
      if [[ ! -d /etc/openvpn ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/openvpn.sh \
        && chmod +x openvpn.sh && ./openvpn.sh
      fi
      systemctl stop openvpn
      apt-get -y purge --auto-remove openvpn && sleep 3
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej openvpn... ${CLR}"
      wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/openvpn.sh \
      && chmod +x openvpn.sh && ./openvpn.sh
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang openvpn? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej openvpn... ${CLR}"
      apt-get -y purge --auto-remove openvpn
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  getPortTCP=$(grep -w 'port' /etc/openvpn/default.conf | cut -d ' ' -f 2)
  clear && echo
  echo -e "${MAGENTA}Secara lalai openvpn menggunakan${CLR} ${GREEN}$getPortTCP${CLR} ${MAGENTA}untuk sambungan TCP${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -r -p "Masukkan port baharu: " readPortTCP
      if [[ ! -z $readPortTCP && $readPortTCP =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortTCP | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -r -p "Masukkan semula port baharu: " readPortTCP
        fi

        systemctl stop openvpn@default
        sed -i "s|${getPortTCP}|${readPortTCP}|g" /etc/openvpn/default.conf
        systemctl start openvpn@default
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
    esac
  done

  getPortTLS=$(grep -w 'port' /etc/openvpn/stunnel.conf | cut -d ' ' -f 2)
  clear && echo
  echo -e "${MAGENTA}Secara lalai openvpn menggunakan${CLR} ${GREEN}$getPortTLS${CLR} ${MAGENTA}untuk sambungan TLS${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -r -p "Masukkan port baharu: " readPortTLS
      if [[ ! -z $readPortTLS && $readPortTLS =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortTLS | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -r -p "Masukkan semula port baharu: " readPortTLS
        fi

        systemctl stop openvpn@stunnel
        systemctl stop stunnel4
        sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/openvpn/stunnel.conf
        sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/stunnel/stunnel.conf
        systemctl start openvpn@stunnel
        systemctl start stunnel4
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function detail {
  local unitName=$(systemctl show openvpn.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show openvpn.service -p Description | cut -d '=' -f 2)
  local isActiveTCP=$(systemctl is-active openvpn@default.service)
  local isEnableTCP=$(systemctl is-enabled openvpn@default.service)
  local isActiveTLS=$(systemctl is-active openvpn@stunnel.service)
  local isEnableTLS=$(systemctl is-enabled openvpn@stunnel.service)
  local getPortTCP=$(grep -w 'port' /etc/openvpn/default.conf | cut -d ' ' -f 2)
  local getPortTLS=$(grep -w 'port' /etc/openvpn/stunnel.conf | cut -d ' ' -f 2)

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name        ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc        ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status(tcp) ${CLR}:${GREEN} $isActiveTCP & $isEnableTCP${CLR}"
  echo -e "${YELLOW} Status(tls) ${CLR}:${GREEN} $isActiveTLS & $isEnableTLS${CLR}"
  echo -e "${YELLOW} Ports       ${CLR}:${GREEN} $getPortTCP(tcp) | $getPortTLS(tls)${CLR}"
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

[[ -d /etc/openvpn ]] && _menu || install