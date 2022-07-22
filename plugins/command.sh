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

if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

if [[ $ID == "debian" ]]; then
  debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
  if [[ $debianVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

if [[ ! -d /usr/local/cybertize/plugins/dropbear ]]; then
  mkdir -p /usr/local/cybertize/plugins/dropbear
fi
if [[ ! -d /usr/local/cybertize/plugins/openvpn ]]; then
  mkdir -p /usr/local/cybertize/plugins/openvpn
fi
if [[ ! -d /usr/local/cybertize/plugins/shadowsocks ]]; then
  mkdir -p /usr/local/cybertize/plugins/shadowsocks
fi
if [[ ! -d /usr/local/cybertize/plugins/service ]]; then
  mkdir -p /usr/local/cybertize/plugins/service
fi
if [[ ! -d /usr/local/cybertize/plugins/server ]]; then
  mkdir -p /usr/local/cybertize/plugins/server
fi

echo -en "[MAIN MENU] Downloading file menu... "
wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/menu.sh'
chmod +x /usr/local/bin/menu
echo -e "${GREEN}[ DONE ]${CLR}"

##
# DROPBEAR
##
echo -en "[DROPBEAR] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/dropbear/create.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/create.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/dropbear/renew.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/renew.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/dropbear/login.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/login.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/dropbear/lists.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/lists.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file password... "
wget -q -O /usr/local/cybertize/plugins/dropbear/password.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/password.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/password.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file lock... "
wget -q -O /usr/local/cybertize/plugins/dropbear/lock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/lock.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/lock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file unlock... "
wget -q -O /usr/local/cybertize/plugins/dropbear/unlock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/unlock.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/unlock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[DROPBEAR] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/dropbear/delete.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/account/delete.sh'
chmod +x /usr/local/cybertize/plugins/dropbear/delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SHADOWSOCKS
##
echo -en "[SHADOWSOCKS] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/create.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/create.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/renew.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/renew.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/login.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/login.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/lists.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/lists.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file password... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/password.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/password.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/password.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file lock... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/lock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/lock.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/lock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file unlock... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/unlock.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/unlock.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/unlock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/shadowsocks/delete.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/shadowsocks/delete.sh'
chmod +x /usr/local/cybertize/plugins/shadowsocks/delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SERVICE
##
echo -en "[SERVICE] Downloading file nginx... "
wget -q -O /usr/local/cybertize/plugins/service/nginx.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/nginx.sh'
chmod +x /usr/local/cybertize/plugins/service/nginx.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file dropbear... "
wget -q -O /usr/local/cybertize/plugins/service/dropbear.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/dropbear.sh'
chmod +x /usr/local/cybertize/plugins/service/dropbear.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file openvpn... "
wget -q -O /usr/local/cybertize/plugins/service/openvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/openvpn.sh'
chmod +x /usr/local/cybertize/plugins/service/openvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file shadowsocks... "
wget -q -O /usr/local/cybertize/plugins/service/shadowsocks.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/shadowsocks.sh'
chmod +x /usr/local/cybertize/plugins/service/shadowsocks.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file squid... "
wget -q -O /usr/local/cybertize/plugins/service/squid.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/squid.sh'
chmod +x /usr/local/cybertize/plugins/service/squid.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file ohpserver... "
wget -q -O /usr/local/cybertize/plugins/service/ohpserver.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/ohpserver.sh'
chmod +x /usr/local/cybertize/plugins/service/ohpserver.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file stunnel... "
wget -q -O /usr/local/cybertize/plugins/service/stunnel.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/stunnel.sh'
chmod +x /usr/local/cybertize/plugins/service/stunnel.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file badvpn... "
wget -q -O /usr/local/cybertize/plugins/service/badvpn.sh 'https://raw.githubusercontent.com/cybertize/axis/dev/plugins/service/badvpn.sh'
chmod +x /usr/local/cybertize/plugins/service/badvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

# delete command.sh script
rm ~/command.sh
