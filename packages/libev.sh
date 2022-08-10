#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
WHITE="\e[37;1m"
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
        "3011": "123@ABC"
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
        "3164": "123@ABC"
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

if [[ ! -f /etc/shadowsocks-libev/.accounts ]]; then
  touch /etc/shadowsocks-libev/.accounts
fi

rm ~/shadowsocks.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} shadowsocks.sh                                ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install shadowsocks automatic       ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3