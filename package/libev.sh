#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin shadowsocks-libev package installation        "
echo "====================================================="

PASS=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

apt-get -y install netcat netcat-openbsd
apt-get -y install pwgen qrencode
apt-get -y install shadowsocks-libev
apt-get -y install simple-obfs
systemctl stop shadowsocks-libev
systemctl disable shadowsocks-libev

cat >/etc/shadowsocks-libev/obfshttp.json <<-EOF
{
    "server": "0.0.0.0",
    "port_password": {
        "3011": "$PASS"
    },
    "timeout": 300,
    "method": "aes-256-gcm",
    "mode": "tcp_and_udp",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=http"
}
EOF

echo "Description=shadowsocks-libev Service
Documentation=https://github.com/cybertize/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ss-manager --executable /usr/bin/ss-server -c /etc/shadowsocks-libev/obfshttp.json
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/shadowsocks-obfshttp.service
systemctl daemon-reload
systemctl enable shadowsocks-obfshttp

cat >/etc/shadowsocks-libev/obfstls.json <<-EOF
{
    "server": "0.0.0.0",
    "port_password": {
        "3164": "$PASS"
    },
    "timeout": 300,
    "method": "aes-256-gcm",
    "mode": "tcp_and_udp",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=tls"
}
EOF

echo "Description=shadowsocks-libev Service
Documentation=https://github.com/cybertize/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ss-manager --executable /usr/bin/ss-server -c /etc/shadowsocks-libev/obfstls.json
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/shadowsocks-obfstls.service
systemctl daemon-reload
systemctl enable shadowsocks-obfstls

if [[ ! -f /etc/shadowsocks-libev/accounts ]]; then
    touch /etc/shadowsocks-libev/accounts
fi

rm ~/libev.sh
echo "====================================================="
echo " Name: shadowsocks.sh                                "
echo " Desc: Script to install shadowsocks automatic       "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5