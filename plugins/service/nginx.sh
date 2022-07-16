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
    read -p "Teruskan dengan pemasangan semula? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      if [[ ! -f /etc/nginx/nginx.conf ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/nginx.sh \
        && chmod +x nginx.sh && ./nginx.sh
      fi
      systemctl stop nginx
      apt-get -y -qq --autoremove purge nginx
      wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/nginx.sh \
      && chmod +x nginx.sh && ./nginx.sh
      ;;
    [Nn]) nginx_menu && break ;;
    esac
  done
}

function uninstall_package {
  while true; do
    read -p "Adakah anda pasti mahu menyahpasang nginx? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop nginx
      apt-get -y -qq --autoremove purge nginx
      echo "Bersihkan & Keluarkan pakej nginx" && exit 0
      ;;
    [Nn]) nginx_menu && break ;;
    esac
  done
}

function configure_package {
  getPort=($(netstat -tlpn | grep nginx | grep -w 'tcp' | awk '{print $4}' | cut -d ':' -f 2))
  clear && echo
  echo "Secara lalai nginx mengunakan port ${getPort[1]} untuk sambungan HTTP"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baru untuk HTTP: " readPortHTTP
      if [[ ! -z $readPortHTTP && $readPortHTTP =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortHTTP | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop nginx
        sed -i "s|${getPort[1]}|${readPortHTTP}|g" /etc/nginx/sites-enabled/default
        systemctl start nginx
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn]) echo "Tiada perubahan dibuat" && break ;;
    esac
  done

  clear && echo
  echo "Secara lalai nginx mengunakan port ${getPort[0]} untuk sambungan HTTPS"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baru untuk HTTPS: " readPortHTTPS
      if [[ ! -z $readPortHTTPS && $readPortHTTPS =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortHTTPS | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop nginx
        sed -i "s|${getPort[0]}|${readPortHTTPS}|g" /etc/nginx/sites-enabled/default
        systemctl start nginx
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn]) nginx_menu && break ;;
    esac
  done
}

function detail_package {
  local unitName=$(systemctl show nginx.service -p Names | cut -d '=' -f 2)
  local unitDesc="A high performance web server"
  local isActive=$(systemctl is-active nginx.service)
  local isEnable=$(systemctl is-enabled nginx.service)
  local getPorts=($(netstat -tlpn | grep nginx | grep -w 'tcp' | awk '{print $4}' | cut -d ':' -f 2))

  clear && echo
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive & $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} ${getPorts[1]}(http) | ${getPorts[0]}(https)${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function nginx_menu {
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
    *) nginx_menu ;;
    esac
  done
}

[[ -f /etc/nginx/nginx.conf ]] && nginx_menu || install_package