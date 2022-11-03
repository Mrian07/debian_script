#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

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
wget -q -O /usr/local/bin/menu 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/menu.sh'
chmod +x /usr/local/bin/menu
echo -e "${GREEN}[ DONE ]${CLR}"

##
# DROPBEAR & OPENVPN
##
echo -en "[SSHD & OVPN] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/acc-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/create.sh'
chmod +x /usr/local/cybertize/plugins/acc-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/acc-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/renew.sh'
chmod +x /usr/local/cybertize/plugins/acc-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/acc-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/login.sh'
chmod +x /usr/local/cybertize/plugins/acc-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/acc-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/lists.sh'
chmod +x /usr/local/cybertize/plugins/acc-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file password... "
wget -q -O /usr/local/cybertize/plugins/acc-password.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/password.sh'
chmod +x /usr/local/cybertize/plugins/acc-password.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file lock... "
wget -q -O /usr/local/cybertize/plugins/acc-lock.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/lock.sh'
chmod +x /usr/local/cybertize/plugins/acc-lock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file unlock... "
wget -q -O /usr/local/cybertize/plugins/acc-unlock.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/unlock.sh'
chmod +x /usr/local/cybertize/plugins/acc-unlock.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SSHD & OVPN] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/acc-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/account/delete.sh'
chmod +x /usr/local/cybertize/plugins/acc-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SHADOWSOCKS
##
echo
echo -en "[SHADOWSOCKS] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/libev-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/libev/create.sh'
chmod +x /usr/local/cybertize/plugins/libev-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/libev-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/libev/renew.sh'
chmod +x /usr/local/cybertize/plugins/libev-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/libev-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/libev/login.sh'
chmod +x /usr/local/cybertize/plugins/libev-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/libev-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/libev/lists.sh'
chmod +x /usr/local/cybertize/plugins/libev-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SHADOWSOCKS] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/libev-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/libev/delete.sh'
chmod +x /usr/local/cybertize/plugins/libev-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# V2RAY
##
echo
echo -en "[V2RAY] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/v2ray-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/v2ray/create.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/v2ray-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/v2ray/renew.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/v2ray-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/v2ray/login.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/v2ray-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/v2ray/lists.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[V2RAY] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/v2ray-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/v2ray/delete.sh'
chmod +x /usr/local/cybertize/plugins/v2ray-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# XRAY
##
echo
echo -en "[XRAY] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/xray-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/xray/create.sh'
chmod +x /usr/local/cybertize/plugins/xray-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/xray-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/xray/renew.sh'
chmod +x /usr/local/cybertize/plugins/xray-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/xray-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/xray/login.sh'
chmod +x /usr/local/cybertize/plugins/xray-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/xray-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/xray/lists.sh'
chmod +x /usr/local/cybertize/plugins/xray-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[XRAY] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/xray-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/xray/delete.sh'
chmod +x /usr/local/cybertize/plugins/xray-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# WIREGUARD
##
echo
echo -en "[WIREGUARD] Downloading file create... "
wget -q -O /usr/local/cybertize/plugins/wireguard-create.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/wireguard/create.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-create.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file renew... "
wget -q -O /usr/local/cybertize/plugins/wireguard-renew.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/wireguard/renew.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-renew.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file login... "
wget -q -O /usr/local/cybertize/plugins/wireguard-login.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/wireguard/login.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-login.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file lists... "
wget -q -O /usr/local/cybertize/plugins/wireguard-lists.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/wireguard/lists.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-lists.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[WIREGUARD] Downloading file delete... "
wget -q -O /usr/local/cybertize/plugins/wireguard-delete.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/wireguard/delete.sh'
chmod +x /usr/local/cybertize/plugins/wireguard-delete.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SERVICE
##
echo
echo -en "[SERVICE] Downloading file nginx... "
wget -q -O /usr/local/cybertize/plugins/service-nginx.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/nginx.sh'
chmod +x /usr/local/cybertize/plugins/service-nginx.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file dropbear... "
wget -q -O /usr/local/cybertize/plugins/service-dropbear.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/dropbear.sh'
chmod +x /usr/local/cybertize/plugins/service-dropbear.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file openvpn... "
wget -q -O /usr/local/cybertize/plugins/service-openvpn.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/openvpn.sh'
chmod +x /usr/local/cybertize/plugins/service-openvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file shadowsocks... "
wget -q -O /usr/local/cybertize/plugins/service-libev.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/libev.sh'
chmod +x /usr/local/cybertize/plugins/service-libev.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file trojan... "
wget -q -O /usr/local/cybertize/plugins/service-trojan.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/trojan.sh'
chmod +x /usr/local/cybertize/plugins/service-trojan.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file v2ray... "
wget -q -O /usr/local/cybertize/plugins/service-v2ray.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/v2ray.sh'
chmod +x /usr/local/cybertize/plugins/service-v2ray.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file xray... "
wget -q -O /usr/local/cybertize/plugins/service-xray.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/xray.sh'
chmod +x /usr/local/cybertize/plugins/service-xray.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file wireguard... "
wget -q -O /usr/local/cybertize/plugins/service-wireguard.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/wireguard.sh'
chmod +x /usr/local/cybertize/plugins/service-wireguard.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file squid... "
wget -q -O /usr/local/cybertize/plugins/service-squid.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/squid.sh'
chmod +x /usr/local/cybertize/plugins/service-squid.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file ohpserver... "
wget -q -O /usr/local/cybertize/plugins/service-ohpserver.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/ohpserver.sh'
chmod +x /usr/local/cybertize/plugins/service-ohpserver.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file websocket... "
wget -q -O /usr/local/cybertize/plugins/service-websocket.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/websocket.sh'
chmod +x /usr/local/cybertize/plugins/service-websocket.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file stunnel... "
wget -q -O /usr/local/cybertize/plugins/service-stunnel.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/stunnel.sh'
chmod +x /usr/local/cybertize/plugins/service-stunnel.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVICE] Downloading file badvpn... "
wget -q -O /usr/local/cybertize/plugins/service-badvpn.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/service/badvpn.sh'
chmod +x /usr/local/cybertize/plugins/service-badvpn.sh
echo -e "${GREEN}[ DONE ]${CLR}"

##
# SERVER
##
echo
echo -en "[SERVER] Downloading file details... "
wget -q -O /usr/local/cybertize/plugins/detail.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/server/details.sh'
chmod +x /usr/local/cybertize/plugins/detail.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVER] Downloading file backup... "
wget -q -O /usr/local/cybertize/plugins/backup.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/server/backup.sh'
chmod +x /usr/local/cybertize/plugins/backup.sh
echo -e "${GREEN}[ DONE ]${CLR}"

echo -en "[SERVER] Downloading file restore... "
wget -q -O /usr/local/cybertize/plugins/restore.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/server/restore.sh'
chmod +x /usr/local/cybertize/plugins/restore.sh
echo -e "${GREEN}[ DONE ]${CLR}"

# echo -en "[SERVER] Downloading file cloudflare... "
# wget -q -O /usr/local/cybertize/plugins/cloudflare.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/server/cloudflare.sh'
# chmod +x /usr/local/cybertize/plugins/cloudflare.sh
# echo -e "${GREEN}[ DONE ]${CLR}"

# echo -en "[SERVER] Downloading file digitalocean... "
# wget -q -O /usr/local/cybertize/plugins/digitalocean.sh 'https://raw.githubusercontent.com/cybertize/debian/buster/plugin/server/digitalocean.sh'
# chmod +x /usr/local/cybertize/plugins/digitalocean.sh
# echo -e "${GREEN}[ DONE ]${CLR}"

# delete command.sh script
rm ~/command.sh
echo "" && sleep 3