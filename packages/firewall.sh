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

##
# FAIL2BAN
##
apt-get -y install fail2ban
if [[ -f /etc/fail2ban/jail.conf ]]; then
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
fi

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} fail2ban.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install fail2ban automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3

##
# DDOS-DEFLATE
##
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

echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} ddosdef.sh                                    ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install ddos-deflate automatic      ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3

##
# IPTABLES
##
export DEBIAN_FRONTEND=noninteractive
apt-get -yqq install iptables-persistent

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.20.0.0/24 -o eth0 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 10.20.0.0/24 -d 0.0.0.0/0 -o eth0 -j MASQUERADE

iptables -A INPUT -p tcp -m limit --limit 16/minute --limit-burst 32 -j REJECT
iptables -A INPUT -p udp -m limit --limit 16/minute --limit-burst 32 -j REJECT
iptables -A INPUT -p tcp -m connlimit --connlimit-above 16 --connlimit-mask 32 -j REJECT
iptables -A INPUT -p udp -m connlimit --connlimit-above 16 --connlimit-mask 32 -j REJECT

iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

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

rm ~/firewall.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW} Name${CLR}:${GREEN} firewall.sh                                   ${CLR}"
echo -e "${YELLOW} Desc${CLR}:${GREEN} Script to install firewall automatic          ${CLR}"
echo -e "${YELLOW} Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
