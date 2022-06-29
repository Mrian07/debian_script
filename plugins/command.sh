#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

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
  if [[ ! -d /usr/local/cybertize/plugins/account ]]; then
    mkdir -p /usr/local/cybertize/plugins/account
  fi
  if [[ ! -d /usr/local/cybertize/plugins/service ]]; then
    mkdir -p /usr/local/cybertize/plugins/service
  fi
  if [[ ! -d /usr/local/cybertize/plugins/server ]]; then
    mkdir -p /usr/local/cybertize/plugins/server
  fi

  wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/menu.sh'
  chmod +x /usr/local/bin/menu

  wget -q -O /usr/local/cybertize/plugins/account/create.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/create.sh'
  wget -q -O /usr/local/cybertize/plugins/account/renew.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/renew.sh'
  wget -q -O /usr/local/cybertize/plugins/account/login.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/login.sh'
  wget -q -O /usr/local/cybertize/plugins/account/lists.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/lists.sh'
  wget -q -O /usr/local/cybertize/plugins/account/password.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/password.sh'
  wget -q -O /usr/local/cybertize/plugins/account/lock.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/lock.sh.sh'
  wget -q -O /usr/local/cybertize/plugins/account/unlock.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/unlock.sh'
  wget -q -O /usr/local/cybertize/plugins/account/delete.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/account/delete.sh'

  wget -q -O /usr/local/cybertize/plugins/service/nginx.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/nginx.sh'
  wget -q -O /usr/local/cybertize/plugins/service/dropbear.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/dropbear.sh'
  wget -q -O /usr/local/cybertize/plugins/service/openvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/openvpn.sh'
  wget -q -O /usr/local/cybertize/plugins/service/squid.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/squid.sh'
  wget -q -O /usr/local/cybertize/plugins/service/stunnel.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/stunnel.sh'
  wget -q -O /usr/local/cybertize/plugins/service/badvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/default/plugins/service/badvpn.sh'
}

function foot_section() {
  rm ~/command.sh

  echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo -e "${YELLOW} Name${CLR}:${GREEN} command.sh                                    ${CLR}"
  echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install command automatic           ${CLR}"
  echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
  echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
  echo
}

function install_command() {
  check_root
  check_virtual
  check_distro
  head_section
  body_section
  foot_section
}
install_command