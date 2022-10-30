#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin badvpn-udpgw package installation             "
echo "====================================================="

wget -q 'https://github.com/shadowsocks/badvpn/archive/refs/heads/master.zip'
unzip master.zip && rm -f master.zip
cd badvpn-master || exit
cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install
cd && rm -r badvpn-master

echo "Description=BadVPN-udpgw Service
Documentation=https://github.com/ambrop72/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/badvpn-udpgw.service

systemctl daemon-reload
systemctl enable badvpn-udpgw
rm ~/badvpn.sh

echo "====================================================="
echo " Name: badvpn.sh                                     "
echo " Desc: Script to install badvpn automatic            "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5