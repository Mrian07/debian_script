#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

clear && echo
echo -e "${RED}=====================================================${CLR}"
echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo -e "${RED}=====================================================${CLR}"
echo

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

rm ~/command.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} command.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install command automatic           ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo