#!/bin/bash

[[ "$USER" != root ]] && exit 1

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
echo -e "====================================================="
echo
echo -e " Name: websocket.sh                                  "
echo -e " Desc: Script to install websocket automatic         "
echo -e " Auth: Doctype <cybertizedevel@gmail.com>            "
echo
echo -e "====================================================="
sleep 3