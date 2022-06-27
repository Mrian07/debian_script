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

wget -q 'https://github.com/shadowsocks/badvpn/archive/refs/heads/master.zip'
unzip master.zip && rm -f master.zip
cd badvpn-master
cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install
cd && rm -r badvpn-master

echo "Description=Badvpn-udpgw Service
Documentation=https://github.com/ambrop72/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/badvpn-udpgw.service

systemctl daemon-reload
systemctl enable badvpn-udpgw

# delete badvpn script
rm ~/badvpn.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} badvpn.sh                                     ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install badvpn automatic            ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo