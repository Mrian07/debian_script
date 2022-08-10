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

wget -q -O /usr/local/bin/ws-dropbear 'https://raw.githubusercontent.com/cybertize/axis/dev/sources/websocket/ws-dropbear.py'
wget -q -O /usr/local/bin/ws-openvpn 'https://raw.githubusercontent.com/cybertize/buster/axis/sources/websocket/ws-openvpn.py'
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-openvpn

cat >/etc/systemd/system/websocket-dropbear.service <<-EOF
[Unit]
Description=Dropbear Websocket
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-dropbear
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/websocket-openvpn.service <<-EOF
[Unit]
Description=OpenVPN Websocket
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python -O /usr/local/bin/ws-openvpn

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable websocket-dropbear
systemctl enable websocket-openvpn

rm -f ~/websocket.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} websocket.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install websocket automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3