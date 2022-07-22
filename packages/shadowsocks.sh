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

apt-get -y install rng-tools
echo "HRNGDEVICE=/dev/urandom" >>/etc/default/rng-tools
systemctl restart rng-tools &>/dev/null
apt-get -y install netcat netcat-openbsd
apt-get -y install pwgen qrencode
apt-get -y install shadowsocks-libev
apt-get -y install simple-obfs
systemctl stop shadowsocks-libev
systemctl disable shadowsocks-libev

# ss-manager ss-server -c /etc/shadowsocks-libev/obfs-http.json
# ss-manager --manager-address /var/run/ss-manager.sock --executable ss-server -c /etc/shadowsocks-libev/obfs-http.json -f /var/run/ss-manager.pid
# ss://aes-256-gcm:ABC123@cybertize.ml:8388/?plugin=obfs-server;obfs=http;obfs-host=cybertize.ml#obfshttp
# ports: 8388-8515

cat >/etc/shadowsocks-libev/obfs-http.json <<-EOF
{
    "server":"0.0.0.0",
    "port_password": {
        "8388": "123@ABC"
    },
    "timeout": 300,
    "method":"aes-256-gcm",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
EOF

echo "Description=shadowsocks-libev Service
Documentation=https://github.com/cybertize/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ss-manager --executable /usr/bin/ss-server -c /etc/shadowsocks-libev/obfs-http.json
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/shadowsocks-http.service
systemctl daemon-reload
systemctl enable shadowsocks-http

cat >/etc/shadowsocks-libev/obfs-tls.json <<-EOF
{
    "server":"0.0.0.0",
    "port_password": {
        "8389": "123@ABC"
    },
    "timeout": 300,
    "method":"aes-256-gcm",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
EOF

echo "Description=shadowsocks-libev Service
Documentation=https://github.com/cybertize/
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ss-manager --executable /usr/bin/ss-server -c /etc/shadowsocks-libev/obfs-http.json
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/shadowsocks-tls.service
systemctl daemon-reload
systemctl enable shadowsocks-tls

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