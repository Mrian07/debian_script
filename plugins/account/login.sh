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

function sshd_section() {
  echo "DROPBEAR: LOG MASUK KLIEN"
  echo -e "-----------------------------------------------------"
  cat "/var/log/auth.log" | grep -i dropbear | grep -i "Password auth succeeded" >/tmp/dropbear_users.txt
  cat /tmp/dropbear_users.txt | grep "dropbear\[$sid\]" >/tmp/dropbear_service_id.txt
  getUser=$(cat /tmp/dropbear_service_id.txt | awk '{print $10}')
  getAddr=$(cat /tmp/dropbear_service_id.txt | awk '{print $12}')
  getSID=($(ps aux | grep -i dropbear | awk '{print $2}'))
  if [[ "${#getSID[@]}" -gt 0 ]]; then
    echo "$sid $getUser $getAddr"
  else
    echo -e "${YELLOW} Tiada pengguna log masuk ${CLR}"
  fi
  echo -e "-----------------------------------------------------"
}

function ovpn_section() {
  echo "OPENVPN: LOG MASUK KLIEN"
  echo -e "-----------------------------------------------------"
  if [ -f "/var/log/openvpn/status.log" ]; then
    cat /var/log/openvpn/status.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' >/tmp/vpn-login-tcp.txt
    cat /tmp/vpn-login-tcp.txt
  fi
  echo -e "-----------------------------------------------------"
}

function login_user() {
  check_root
  check_virtual
  check_distro
  head_section
  sshd_section
  ovpn_section
  # l2tp_section
  # libev_section
  # ssr_section
  # ssgo_section
  # v2ray_section
  # xray_section
  # wg0_section
  foot_section
}
login_user