#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
  getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  if [[ $getVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

echo -en "[MAIN MENU] Downloading file menu... "
wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/menu.sh'
chmod +x /usr/local/bin/menu
echo -e "${GREEN}[ DONE ]${CLR}"

##
# DROPBEAR
##
echo -en "[ACCOUNT] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/acc-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/create.sh'
chmod +x /usr/local/cybertize/plugins/acc-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/acc-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/renew.sh'
chmod +x /usr/local/cybertize/plugins/acc-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/acc-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/login.sh'
chmod +x /usr/local/cybertize/plugins/acc-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/acc-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/lists.sh'
chmod +x /usr/local/cybertize/plugins/acc-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file password... "
wget -q -O /usr/local/cybertize/plugins/acc-password.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/password.sh'
chmod +x /usr/local/cybertize/plugins/acc-password.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file lock... "
wget -q -O /usr/local/cybertize/plugins/acc-lock.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/lock.sh'
chmod +x /usr/local/cybertize/plugins/acc-lock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file unlock... "
wget -q -O /usr/local/cybertize/plugins/acc-unlock.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/unlock.sh'
chmod +x /usr/local/cybertize/plugins/acc-unlock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[ACCOUNT] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/acc-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/account/delete.sh'
chmod +x /usr/local/cybertize/plugins/acc-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SHADOWSOCKS
##
echo -en "[SHADOWSOCKS] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/libev-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/libev/create.sh'
chmod +x /usr/local/cybertize/plugins/libev-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/libev-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/libev/renew.sh'
chmod +x /usr/local/cybertize/plugins/libev-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/libev-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/libev/login.sh'
chmod +x /usr/local/cybertize/plugins/libev-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/libev-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/libev/lists.sh'
chmod +x /usr/local/cybertize/plugins/libev-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/libev-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/libev/delete.sh'
chmod +x /usr/local/cybertize/plugins/libev-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# V2RAY
##
echo -en "[V2RAY] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/v2ray-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/v2ray/create.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/v2ray-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/v2ray/renew.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/v2ray-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/v2ray/login.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/v2ray-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/v2ray/lists.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/v2ray-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/v2ray/delete.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# XRAY
##
echo -en "[XRAY] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/xray-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/xray/create.sh'
chmod +x /usr/local/cybertize/plugins/xray-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/xray-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/xray/renew.sh'
chmod +x /usr/local/cybertize/plugins/xray-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/xray-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/xray/login.sh'
chmod +x /usr/local/cybertize/plugins/xray-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/xray-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/xray/lists.sh'
chmod +x /usr/local/cybertize/plugins/xray-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/xray-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/xray/delete.sh'
chmod +x /usr/local/cybertize/plugins/xray-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# WIREGUARD
##
echo -en "[WIREGUARD] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/wireguard-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/wireguard/create.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/wireguard-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/wireguard/renew.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/wireguard-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/wireguard/login.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/wireguard-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/wireguard/lists.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/wireguard-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/wireguard/delete.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SERVICE
##
echo -en "[SERVICE] Downloading file nginx... "
wget -q -O /usr/local/cybertize/plugins/service-nginx.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/nginx.sh'
chmod +x /usr/local/cybertize/plugins/service-nginx.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file dropbear... "
wget -q -O /usr/local/cybertize/plugins/service-dropbear.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/dropbear.sh'
chmod +x /usr/local/cybertize/plugins/service-dropbear.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file openvpn... "
wget -q -O /usr/local/cybertize/plugins/service-openvpn.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/openvpn.sh'
chmod +x /usr/local/cybertize/plugins/service-openvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file shadowsocks... "
wget -q -O /usr/local/cybertize/plugins/service-libev.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/libev.sh'
chmod +x /usr/local/cybertize/plugins/service-libev.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file trojan... "
wget -q -O /usr/local/cybertize/plugins/service-trojan.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/trojan.sh'
chmod +x /usr/local/cybertize/plugins/service-trojan.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file v2ray... "
wget -q -O /usr/local/cybertize/plugins/service-v2ray.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/v2ray.sh'
chmod +x /usr/local/cybertize/plugins/service-v2ray.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file xray... "
wget -q -O /usr/local/cybertize/plugins/service-xray.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/xray.sh'
chmod +x /usr/local/cybertize/plugins/service-xray.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file wireguard... "
wget -q -O /usr/local/cybertize/plugins/service-wireguard.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/wireguard.sh'
chmod +x /usr/local/cybertize/plugins/service-wireguard.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file squid... "
wget -q -O /usr/local/cybertize/plugins/service-squid.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/squid.sh'
chmod +x /usr/local/cybertize/plugins/service-squid.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file ohpserver... "
wget -q -O /usr/local/cybertize/plugins/service-ohpserver.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/ohpserver.sh'
chmod +x /usr/local/cybertize/plugins/service-ohpserver.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file websocket... "
wget -q -O /usr/local/cybertize/plugins/service-websocket.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/websocket.sh'
chmod +x /usr/local/cybertize/plugins/service-websocket.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file stunnel... "
wget -q -O /usr/local/cybertize/plugins/service-stunnel.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/stunnel.sh'
chmod +x /usr/local/cybertize/plugins/service-stunnel.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file badvpn... "
wget -q -O /usr/local/cybertize/plugins/service-badvpn.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugins/service/badvpn.sh'
chmod +x /usr/local/cybertize/plugins/service-badvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

# delete command.sh script
rm ~/command.sh