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

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/utility/.env | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/utility/.env | cut -d '=' -f 2 | tr -d '"')
NAME=$(grep -sw 'NAME' /usr/local/cybertize/utility/.env | cut -d '=' -f 2 | tr -d '"')

apt-get -y install squid
systemctl stop squid

echo "acl localnet src 0.0.0.1-0.255.255.255
acl localnet src 10.0.0.0/8
acl localnet src 100.64.0.0/10
acl localnet src 169.254.0.0/16
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10

acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl NAME dst IPADDR

http_access allow NAME
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost
http_access allow localhost manager
http_access deny manager
http_access deny to_localhost
include /etc/squid/conf.d/*

http_access deny all
http_port 3128

coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname DOMAIN" >/etc/squid/squid.conf

sed -e "s/DOMAIN/$DOMAIN/" /etc/squid/squid.conf
sed -e "s/NAME/$NAME/g" /etc/squid/squid.conf
sed -e "s/IPADDR/$IPADDR/" /etc/squid/squid.conf

# delete squid script
rm ~/squid.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${YELLOW} Name${CLR}:${GREEN} squid.sh                                      ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install squid automatic             ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo