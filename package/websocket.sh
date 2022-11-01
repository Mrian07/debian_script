#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin websocket package installation                "
echo "====================================================="

wget -q -O /usr/local/bin/websocket-dropbear 'https://raw.githubusercontent.com/cybertize/axis/dev/source/websocket/websocket-dropbear'
wget -q -O /usr/local/bin/websocket-openvpn 'https://raw.githubusercontent.com/cybertize/buster/axis/source/websocket/websocket-openvpn'
chmod +x /usr/local/bin/websocket-dropbear
chmod +x /usr/local/bin/websocket-openvpn

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
ExecStart=/usr/bin/python -O /usr/local/bin/websocket-dropbear
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
ExecStart=/usr/bin/python -O /usr/local/bin/websocket-openvpn

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable websocket-dropbear
systemctl enable websocket-openvpn

rm -f ~/websocket.sh
echo "====================================================="
echo " Name: websocket.sh                                  "
echo " Desc: Script to install websocket automatic         "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5
