#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

clear && echo
echo -e "${RED}=====================================================${CLR}"
echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo -e "${RED}=====================================================${CLR}"
echo

export DEBIAN_FRONTEND=noninteractive

apt-get -yqq install cryptsetup-initramfs &>/dev/null
apt-get -yqq install dropbear &>/dev/null
systemctl stop dropbear &>/dev/null

cp /etc/default/dropbear /etc/default/dropbear.orig

echo 'NO_START=0
DROPBEAR_PORT=2200
DROPBEAR_EXTRA_ARGS="-p 2020"
DROPBEAR_BANNER="/etc/issue.net"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536' >/etc/default/dropbear

rm -f ~/dropbear.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} dropbear.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install dropbear automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo
