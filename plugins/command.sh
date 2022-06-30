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

function body() {
  if [[ ! -d /usr/local/cybertize/plugins/account ]]; then
    mkdir -p /usr/local/cybertize/plugins/account
  fi
  if [[ ! -d /usr/local/cybertize/plugins/service ]]; then
    mkdir -p /usr/local/cybertize/plugins/service
  fi
  if [[ ! -d /usr/local/cybertize/plugins/server ]]; then
    mkdir -p /usr/local/cybertize/plugins/server
  fi

  echo -en "Downloading file menu... "
  wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/menu.sh'
  chmod +x /usr/local/bin/menu
  echo -e "[DONE]"

  echo -en "Downloading file create... "
  wget -q -O /usr/local/cybertize/plugins/account/create.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/create.sh'
  echo -e "[DONE]"

  echo -en "Downloading file renew... "
  wget -q -O /usr/local/cybertize/plugins/account/renew.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/renew.sh'
  echo -e "[DONE]"

  echo -en "Downloading file login... "
  wget -q -O /usr/local/cybertize/plugins/account/login.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/login.sh'
  echo -e "[DONE]"

  echo -en "Downloading file lists... "
  wget -q -O /usr/local/cybertize/plugins/account/lists.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/lists.sh'
  echo -e "[DONE]"

  echo -en "Downloading file password... "
  wget -q -O /usr/local/cybertize/plugins/account/password.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/password.sh'
  echo -e "[DONE]"

  echo -en "Downloading file lock... "
  wget -q -O /usr/local/cybertize/plugins/account/lock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/lock.sh'
  echo -e "[DONE]"

  echo -en "Downloading file unlock... "
  wget -q -O /usr/local/cybertize/plugins/account/unlock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/unlock.sh'
  echo -e "[DONE]"

  echo -en "Downloading file delete... "
  wget -q -O /usr/local/cybertize/plugins/account/delete.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/delete.sh'
  echo -e "[DONE]"

  echo -en "Downloading file nginx... "
  wget -q -O /usr/local/cybertize/plugins/service/nginx.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/nginx.sh'
  echo -e "[DONE]"

  echo -en "Downloading file dropbear... "
  wget -q -O /usr/local/cybertize/plugins/service/dropbear.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/dropbear.sh'
  echo -e "[DONE]"

  echo -en "Downloading file openvpn... "
  wget -q -O /usr/local/cybertize/plugins/service/openvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/openvpn.sh'
  echo -e "[DONE]"

  echo -en "Downloading file squid... "
  wget -q -O /usr/local/cybertize/plugins/service/squid.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/squid.sh'
  echo -e "[DONE]"

  echo -en "Downloading file stunnel... "
  wget -q -O /usr/local/cybertize/plugins/service/stunnel.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/stunnel.sh'
  echo -e "[DONE]"

  echo -en "Downloading file badvpn... "
  wget -q -O /usr/local/cybertize/plugins/service/badvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/badvpn.sh'
  echo -e "[DONE]"
}

function foot() {
  # delete command.sh script
  rm ~/command.sh

  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █${CLR}"
  echo -e "${BLUE}▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █${CLR}"
  echo -e "${BLUE}█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} Name${CLR}:${GREEN} command.sh                                    ${CLR}"
  echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install command automatic           ${CLR}"
  echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function install_command() {
  head
  body
  foot
}
install_command