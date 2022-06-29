#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

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
  clear && echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo "SENARAI AKAUN PENGGUNA"
  echo -e "-----------------------------------------------------"
  getNames=($(grep -sw 'client' /etc/passwd | cut -d : -f 1))
  for user in ${getNames[@]}; do
    getExpDate="$(chage -l $user | grep "Account expires" | awk -F": " '{print $2}')"
    printf "%-15s %2s\n" "$user" "$getExpDate"
  done
  getTotal=${#getNames[@]}
  echo
  echo "JUMLAH : $getTotal pengguna"
  echo -e "===[${RED} DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE. ${CLR}]==="
  echo
}

function lists_user() {
  check_root
  check_virtual
  check_distro
  head_section
  body_section
}
lists_user
