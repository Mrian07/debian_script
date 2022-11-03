#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin iptables package installation                 "
echo "====================================================="

apt-get -y install fail2ban
if [[ -f /etc/fail2ban/jail.conf ]]; then
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
fi

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p tcp -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
# iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

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

iptables-save >/etc/iptables.up.rules
cat >/etc/network/if-pre-up.d/iptables <<-EOF
#!/bin/bash
iptables-restore -n </etc/iptables.up.rules
EOF
chmod +x /etc/network/if-pre-up.d/iptables

rm ~/firewall.sh
echo "====================================================="
echo " Name: firewall.sh                                   "
echo " Desc: Script to install firewall automatic          "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5