#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/.environment | cut -d '=' -f 2 | tr -d '"')

[[ -e /etc/os-release ]] && source /etc/os-release

function head() {
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
    echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
  fi
}

function main() {
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

function foot() {
  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
  echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
  echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
  echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
  echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
  echo -e "${YELLOW}   Kata laluan${CLR}:${GREEN} $getPass${CLR}"
  echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
  echo
  echo -e " TCP Config: https://$DOMAIN/client-tcp.ovpn"
  echo -e " UDP Config: https://$DOMAIN/client-udp.ovpn"
  echo -e " TLS Config: https://$DOMAIN/client-tls.ovpn"
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function create_user() {
  head
  main
  foot
}
create_user