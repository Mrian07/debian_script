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
    read -r -p "Teruskan dengan pemasangan semula? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      if [[ ! -f /usr/local/bin/ohpserver ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/ohpserver.sh \
        && chmod +x ohpserver.sh && ./ohpserver.sh
      fi
      systemctl stop ohp-*.service && sleep 3
      echo -en "${YELLOW}Pasang dan Konfigurasi pakej ohpserver... ${CLR}"
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/ohpserver.sh \
      && chmod +x ohpserver.sh && ./ohpserver.sh
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function uninstall {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang ohpserver? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop ohp-*.service && sleep 3
      echo -en "${YELLOW}Nyahpasang dan Bersihkan pakej ohpserver... ${CLR}"
      rm -f /usr/local/bin/ohpserver
      rm -f /etc/systemd/system/ohp-*.service
      echo -e "${GREEN}[ DONE ]${CLR}" && exit 0
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function configure {
  getPortDropbear=$(grep 'ExecStart' /etc/systemd/system/ohpserver-dropbear.service | awk '{print $3}')
  clear && echo
  echo -e "${MAGENTA}Secara lalai ohpserver mengunakan port${CLR} ${GREEN}$getPortDropbear${CLR} ${MAGENTA}untuk sambungan dropbear${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortDropbear
      if [[ ! -z $readPortDropbear && $readPortDropbear =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i :$readPortDropbear | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -p "Masukkan semula port baharu: " readPortDropbear
        fi

        systemctl stop ohpserver-dropbear
        sed -i "s|${getPortDropbear}|${readPortTCP}|g" /etc/systemd/system/ohpserver-dropbear.service
        systemctl start ohpserver-dropbear
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
    esac
  done

  getPortOpenvpn=$(grep 'ExecStart' /etc/systemd/system/ohpserver-openvpn.service | awk '{print $3}')
  clear && echo
  echo -e "${MAGENTA}Secara lalai ohpserver menggunakan${CLR} ${GREEN}$getPortOpenvpn${CLR} ${MAGENTA}untuk sambungan openvpn${CLR}"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortOpenvpn
      if [[ ! -z $readPortOpenvpn && $readPortOpenvpn =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i :$readPortOpenvpn | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo -e "${RED}Port sudah digunakan!${CLR}"
          read -p "Masukkan semula port baharu: " readPortOpenvpn
        fi

        systemctl stop dropbear
        sed -i "s|${getPortOpenvpn}|${readPortOpenvpn}|g" /etc/systemd/system/ohpserver-openvpn.service
        systemctl start dropbear
        echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
      fi
      ;;
    [Nn]) _menu && break ;;
    esac
  done
}

function detail {
  local unitName=$(systemctl show ohpserver-dropbear.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show ohpserver-dropbear.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active ohpserver-dropbear.service)
  local isEnable=$(systemctl is-enabled ohpserver-dropbear.service)
  local isActive=$(systemctl is-active ohpserver-openvpn.service)
  local isEnable=$(systemctl is-enabled ohpserver-openvpn.service)
  local PortForDropbear=$(grep 'ExecStart' /etc/systemd/system/ohpserver-dropbear.service | awk '{print $3}')
  local PortForOpenvpn=$(grep 'ExecStart' /etc/systemd/system/ohpserver-openvpn.service | awk '{print $3}')

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name    ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc    ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} OHP Dropbear Status  ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} OHP OpenVPN Status  ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} OHP Dropbear Port   ${CLR}:${GREEN} $PortForDropbear (ohp-dropbear)${CLR}"
  echo -e "${YELLOW} OHP OpenVPN Port   ${CLR}:${GREEN} $PortForOpenvpn (ohp-openvpn)${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function menu {
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
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) _menu ;;
    esac
  done
}

[[ -f /usr/local/bin/ohpserver ]] && _menu || install
