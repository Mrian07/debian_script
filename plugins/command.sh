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

wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/menu.sh'
chmod +x /usr/local/bin/menu

wget -q -O /usr/local/cybertize/create.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/create.sh'
wget -q -O /usr/local/cybertize/renew.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/renew.sh'
wget -q -O /usr/local/cybertize/login.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/login.sh'
wget -q -O /usr/local/cybertize/lists.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/lists.sh'
wget -q -O /usr/local/cybertize/password.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/password.sh'
wget -q -O /usr/local/cybertize/lock.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/lock.sh.sh'
wget -q -O /usr/local/cybertize/unlock.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/unlock.sh'
wget -q -O /usr/local/cybertize/delete.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/account/delete.sh'

wget -q -O /usr/local/cybertize/nginx.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/nginx.sh'
wget -q -O /usr/local/cybertize/dropbear.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/dropbear.sh'
wget -q -O /usr/local/cybertize/openvpn.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/openvpn.sh'
wget -q -O /usr/local/cybertize/squid.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/squid.sh'
wget -q -O /usr/local/cybertize/stunnel.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/stunnel.sh'
wget -q -O /usr/local/cybertize/badvpn.sh 'https://raw.githubusercontent.com/cybertize/buster/fate/plugins/service/badvpn.sh'

rm ~/command.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} command.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install command automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo