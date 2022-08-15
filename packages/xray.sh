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

PASSWORD=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

apt-get update
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
cp /usr/local/etc/xray/config.json /usr/local/etc/xray/config.json.old

if [[ ! -f /usr/local/etc/xray/accounts ]]; then
  touch /usr/local/etc/xray/accounts
fi

# [XRAY] Trojan TCP-XTLS
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
                        "password":"$PASSWORD",
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
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} xray.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install xray automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>        ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
