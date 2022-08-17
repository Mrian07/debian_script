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

if [[ ! -d /usr/local/etc/v2ray/pki ]]; then
  mkdir /usr/local/etc/v2ray/pki
fi

USERNAME=$(grep -sw 'USERNAME' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASSWORD=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
rm /usr/local/etc/v2ray/config.json

certbot certonly --register-unsafely-without-email --agree-tos --standalone -d v2ray.cybertize.tk --cert-name v2ray
cp /etc/letsencrypt/live/v2ray/fullchain.pem /usr/local/etc/v2ray/fullchain.crt
cp /etc/letsencrypt/live/v2ray/privkey.pem /usr/local/etc/v2ray/private.key

chmod 644 /usr/local/etc/v2ray/fullchain.crt
chmod 644 /usr/local/etc/v2ray/private.key

if [[ ! -f /usr/local/etc/v2ray/accounts ]]; then
  touch /usr/local/etc/v2ray/accounts
fi

# [V2RAY] Trojan TCP-TLS
cat >/usr/local/etc/v2ray/trojan-tcp-tls.json <<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 4154,
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password":"$PASSWORD",
                        "email": "$USERNAME@$DOMAIN"
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
                            "certificateFile": "/usr/local/etc/v2ray/fullchain.crt",
                            "keyFile": "/usr/local/etc/v2ray/private.key"
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

rm -f ~/v2ray.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} v2ray.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install v2ray automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>        ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
