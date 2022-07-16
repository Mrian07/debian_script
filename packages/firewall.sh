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

apt-get -y install fail2ban
if [[ -f /etc/fail2ban/jail.conf ]]; then
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
fi
rm ~/fail2ban.sh

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} fail2ban.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install fail2ban automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 5

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
rm ~/ddosdef.sh

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} ddosdef.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install ddos-deflate automatic      ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 5

export DEBIAN_FRONTEND=noninteractive apt-get -yqq install iptables-persistent

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.20.0.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tun0 -s 10.20.0.0/24 -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 81 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 2200 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 2020 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 1194 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 994 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 587 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 8388 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 3128 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 2000 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 2001 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 7300 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -t mangle -A INPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "peer_id=" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string ".torrent" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "torrent" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "announce" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "info_hash" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "get_peers" --algo bm --to 65535 -j DROP
iptables -t mangle -A INPUT -m string --string "find_node" --algo bm --to 65535 -j DROP

iptables-save >/etc/iptables/rules.v4
iptables-restore -n </etc/iptables/rules.v4

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

ip6tables-save >/etc/iptables/rules.v6
ip6tables-restore -n </etc/iptables/rules.v6
rm ~/iptables.sh

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} iptables.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install iptables automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 5