#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

function installPkg {
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
    [Nn]) stunnelMenu && break ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -p "Adakah anda pasti mahu menyahpasang stunnel? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      systemctl stop stunnel
      apt-get -y purge --autoremove stunnel*
      echo "Bersihkan & Keluarkan pakej stunnel" && exit 0
      ;;
    [Nn]) stunnelMenu && break ;;
    esac
  done
}

function configurePkg {
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
    [Nn]) stunnelMenu && break ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show stunnel4.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show stunnel4.service -p Description | cut -d '=' -f 2)
  local isActive=$(systemctl is-active stunnel4.service)
  local isEnable=$(systemctl is-enabled stunnel4.service)
  local getPorts=($(grep -w 'accept =' /etc/stunnel/stunnel.conf | cut -d '=' -f 2))

  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "BUTIRAN PERKHIDMATAN STUNNEL"
  echo -e "-----------------------------------------------------"
  echo -e "${YELLOW} Name   ${CLR}:${GREEN} $unitName${CLR}"
  echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $unitDesc${CLR}"
  echo -e "${YELLOW} Status ${CLR}:${GREEN} $isActive \& $isEnable${CLR}"
  echo -e "${YELLOW} Ports  ${CLR}:${GREEN} ${getPorts[0]}(dropbear) | ${getPorts[1]}(openvpn)${CLR}"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
}

function stunnelMenu {
  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "MENU STUNNEL"
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
    *) stunnelMenu ;;
    esac
  done
}

[[ -f /etc/stunnel/stunnel.conf ]] && stunnelMenu || installPkg