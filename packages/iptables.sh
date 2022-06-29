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
  export DEBIAN_FRONTEND=noninteractive
  apt-get -yqq install iptables-persistent

  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
  iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i tun0 -s 10.8.0.0/24 -j ACCEPT
  iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
  iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
  iptables -A INPUT -p tcp --dport http -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
  iptables -A INPUT -p tcp --dport https -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -p tcp -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
  iptables -t mangle -A INPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "peer_id=" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string ".torrent" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "torrent" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "announce" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "info_hash" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "get_peers" --algo bm --to 65535 -j DROP
  iptables -t mangle -A INPUT -m string --string "find_node" --algo bm --to 65535 -j DROP

  ip6tables -P INPUT DROP
  ip6tables -P FORWARD DROP
  ip6tables -P OUTPUT ACCEPT

  iptables-save >/etc/iptables/rules.v4
  iptables-restore -n </etc/iptables/rules.v4
  ip6tables-save >/etc/iptables/rules.v6
  ip6tables-restore -n </etc/iptables/rules.v6
}

function foot_section() {
  # delete iptables script
  rm ~/iptables.sh

  echo
  echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
  echo -e "${YELLOW} Name${CLR}:${GREEN} iptables.sh                                   ${CLR}"
  echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install iptables automatic          ${CLR}"
  echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
  echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
  echo
}

function install_package() {
  check_root
  check_virtual
  check_distro
  head_section
  body_section
  foot_section
}
install_package
