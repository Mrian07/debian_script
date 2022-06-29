#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')

function check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
  fi
}

function check_virtual() {
  if [ -f /proc/user_beancounters ]; then
    echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
  fi
}

function check_distro() {
  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
  else
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}

function head_section() {
  clear && echo
  echo -e "${RED}=====================================================${CLR}"
  echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
  echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
  echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
  echo -e "${RED}=====================================================${CLR}"
  echo
}

function body_section() {
  until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
    read -p "Masukkan nama pengguna: " getUser
    if grep -sw "$getUser" /etc/passwd &>/dev/null; then
      echo -e "${RED}Nama pengguna sudah wujud!${CLR}" && exit 1
    fi
  done

  until [[ ! -z $getPass ]]; do
    read -p "Masukkan kata laluan: " getPass
  done

  until [[ ! -z $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
    read -p "Masukkan Tempoh aktif (Hari): " getDuration
  done
  expDate=$(date -d "$getDuration days" +"%F")

  useradd $getUser
  usermod -c "client" $getUser
  usermod -s /bin/false $getUser
  usermod -e $expDate $getUser
  echo -e "$getPass\n$getPass" | passwd $getUser &>/dev/null
}

function foot_section() {
  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo -e "BUAT AKAUN PENGGUNA                                  "
  echo -e "-----------------------------------------------------"
  echo -e " Nama pengguna: $getUser"
  echo -e "   Kata laluan: $getPass"
  echo -e "  Tarikh luput: $expDate"
  echo
  echo -e " https://$DOMAIN/client-tcp.ovpn"
  echo -e " https://$DOMAIN/client-tls.ovpn"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
}

function create_user() {
  check_root
  check_virtual
  check_distro
  head_section
  body_section
  foot_section
}
create_user