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

wget -q https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip && rm ohpserver-linux32.zip
chmod +x ohpserver
mv ohpserver /usr/local/bin/

cat >/etc/systemd/system/ohpserver-dropbear.service <<-EOF
[Unit]
Description=OHP Server Default Server Service
Documentation=https://github.com/cybertize/
After=network.target network-online.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 51104 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:1638
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/ohpserver-openvpn.service <<-EOF
[Unit]
Description=OHP Server Default Server Service
Documentation=https://github.com/cybertize/
After=network.target network-online.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 51509 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:2834
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/ohpserver-libev.service <<-EOF
[Unit]
Description=OHP Server Default Server Service
Documentation=https://github.com/cybertize/
After=network.target network-online.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 58827 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:3621
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ohpserver-dropbear
systemctl enable ohpserver-openvpn
systemctl enable ohpserver-libev

rm -f ~/ohpserver.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} ohpserver.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install ohpserver automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>            ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3