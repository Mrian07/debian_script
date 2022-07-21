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

wget -q https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip && rm ohpserver-linux32.zip
chmod +x ohpserver
mv ohpserver /usr/local/bin/

cat >/etc/systemd/system/ohpserver-dropbear.service <<-EOF
[Unit]
Description=OHP Server
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohpserver -port 2010 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:2200
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/ohpserver-openvpn.service <<-EOF
[Unit]
Description=OHP Server
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohpserver -port 2011 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:1194
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ohpserver-dropbear
systemctl enable ohpserver-openvpn

rm -f ~/ohpserver.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} ohpserver.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install ohpserver automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
