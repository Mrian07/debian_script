#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin ohp-server package installation               "
echo "====================================================="

wget -q https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip && rm ohpserver-linux32.zip
chmod +x ohpserver
mv ohpserver /usr/local/bin/

cat >/etc/systemd/system/ohpserver-dropbear.service <<'EOF'
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

cat >/etc/systemd/system/ohpserver-openvpn.service <<'EOF'
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

systemctl daemon-reload
systemctl enable ohpserver-dropbear
systemctl enable ohpserver-openvpn

rm -f ~/ohpserver.sh
echo "====================================================="
echo " Name: ohpserver.sh                                  "
echo " Desc: Script to install ohpserver automatic         "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5