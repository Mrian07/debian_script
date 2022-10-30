#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin xray package installation                     "
echo "====================================================="

USER=$(grep -sw 'USERNAME' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASS=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
UUID=$(grep -sw 'UUID' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
rm /usr/local/etc/xray/config.json

certbot certonly --register-unsafely-without-email --agree-tos --standalone -d xray.cybertize.tk --cert-name xray
cp /etc/letsencrypt/live/xray/fullchain.pem /usr/local/etc/xray/fullchain.crt
cp /etc/letsencrypt/live/xray/privkey.pem /usr/local/etc/xray/private.key

chmod 644 /usr/local/etc/xray/fullchain.crt
chmod 644 /usr/local/etc/xray/private.key

if [[ ! -f /usr/local/etc/xray/accounts ]]; then
    touch /usr/local/etc/xray/accounts
fi

# [TROJAN] TCP-TLS
cat >/usr/local/etc/xray/trojan-tcp-xtls.json <<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password":"$PASS",
                        "email": "$USER@$DOMAIN"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/fullchain.crt",
                            "keyFile": "/usr/local/etc/xray/private.key"
                        }
                    ]
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# [TROJAN] TCP-XTLS
cat >/usr/local/etc/xray/trojan-tcp-xtls.json <<-EOF
{
    "log": {
        "loglevel": "debug"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password":"$PASS",
                        "flow": "xtls-rprx-direct"
                    }
                ],
                "fallbacks": [
                    {
                        "dest": "/dev/shm/default.sock",
                        "xver": 1
                    },
                    {
                        "alpn": "h2",
                        "dest": "/dev/shm/h2c.sock",
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/fullchain.crt",
                            "keyFile": "/usr/local/etc/xray/private.key"
                            "ocspStapling": 3600
                        }
                    ],
                    "minVersion": "1.2"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

rm -f ~/xray.sh
echo "====================================================="
echo " Name: xray.sh                                       "
echo " Desc: Script to install xray automatic              "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5