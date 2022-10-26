#!/bin/bash

[[ "$USER" != root ]] && exit 1

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

apt-get -y install squid
systemctl stop squid

echo "acl localnet src 10.0.0.0/8
acl localnet src 100.64.0.0/10
acl localnet src 169.254.0.0/16
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16

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
acl $DOMAIN dst $IPADDR

http_access allow localnet
http_access allow localhost
http_access allow localhost manager
http_access allow $DOMAIN
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access deny manager
http_access deny to_localhost

http_access deny all
http_port 3128
http_port 8000

coredump_dir /var/spool/squid
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname $DOMAIN" >/etc/squid/squid.conf
rm ~/squid.sh

echo -e "====================================================="
echo
echo -e " Name: squid.sh                                      "
echo -e " Desc: Script to install squid automatic             "
echo -e " Auth: Doctype <cybertizedevel@gmail.com>            "
echo
echo -e "====================================================="
sleep 3