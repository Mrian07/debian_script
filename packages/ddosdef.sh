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

apt-get -y install dnsutils # nslookup
apt-get -y install tcpdump
apt-get -y install dsniff # tcpkill
apt-get -y install grepcidr

wget -q https://github.com/jgmdev/ddos-deflate/archive/master.zip
unzip master.zip
rm master.zip
cd ddos-deflate-master
bash install.sh
cd && rm -r ddos-deflate-master

systemctl daemon-reload
systemctl enable ddos

# delete ddos-deflate script
rm ~/ddosdef.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} ddosdef.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install ddos-deflate automatic      ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo
