#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin stunnel package installation                  "
echo "====================================================="

apt-get -y install stunnel4
systemctl stop stunnel4

[[ ! -d /etc/ssl/cybertize ]] && mkdir /etc/ssl/cybertize
openssl genrsa -out /etc/ssl/cybertize/key.pem 2048
openssl req -new -x509 -batch \
-key /etc/ssl/cybertize/key.pem \
-out /etc/ssl/cybertize/cert.pem -days 365
openssl dhparam 2048 >>/etc/ssl/cybertize/dh2048.pem

cat /etc/ssl/cybertize/key.pem >/etc/stunnel/stunnel.pem
cat /etc/ssl/cybertize/cert.pem >>/etc/stunnel/stunnel.pem
cat /etc/ssl/cybertize/dh2048.pem >>/etc/stunnel/stunnel.pem
chmod 600 /etc/stunnel/stunnel.pem

cat >/etc/stunnel/stunnel.conf <<-EOF
pid = /var/run/stunnel4.pid
log = append
output = /var/log/stunnel4/stunnel.log
cert = /etc/stunnel/stunnel.pem
client = no

socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear service]
accept = 49727
connect = 127.0.0.1:1359

[openvpn service]
accept = 50389
connect = 127.0.0.1:2751
EOF

echo 'ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
PPP_RESTART=0
RLIMITS="-n 4096"' >/etc/default/stunnel4

rm ~/stunnel.sh
echo "====================================================="
echo " Name: stunnel.sh                                    "
echo " Desc: Script to install stunnel automatic           "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5