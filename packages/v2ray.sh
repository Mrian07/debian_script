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

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
USER=$(grep -sw 'USERNAME' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASS=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
UUID=$(grep -sw 'UUID' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
rm /usr/local/etc/v2ray/config.json

certbot certonly --register-unsafely-without-email --agree-tos --standalone -d v2ray.cybertize.tk --cert-name v2ray
cp /etc/letsencrypt/live/v2ray/fullchain.pem /usr/local/etc/v2ray/fullchain.crt
cp /etc/letsencrypt/live/v2ray/privkey.pem /usr/local/etc/v2ray/private.key

chmod 644 /usr/local/etc/v2ray/fullchain.crt
chmod 644 /usr/local/etc/v2ray/private.key

if [[ ! -d /usr/local/etc/v2ray/clients ]]; then
  mkdir /usr/local/etc/v2ray/clients
fi

if [[ ! -f /usr/local/etc/v2ray/accounts ]]; then
  touch /usr/local/etc/v2ray/accounts
fi

# [TROJAN] TCP-TLS
cat >/usr/local/etc/v2ray/trojan-tcp-tls.json <<-TROJAN1
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
TROJAN1

# [VLESS] GRPC-TLS
cat >/usr/local/etc/v2ray/vless-grpc-tls.json <<-VLESS1
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 5142,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "email": "$USER@$DOMAIN"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "gun",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "$DOMAIN",
                    "alpn": [
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/v2ray/fullchain.crt",
                            "keyFile": "/usr/local/etc/v2ray/private.key"
                        }
                    ]
                },
                "grpcSettings": {
                    "serviceName": "GunService"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        }
    ]
}
VLESS1

# [VLESS] TCP-TLS
cat >/usr/local/etc/v2ray/vless-tcp-tls.json <<-VLESS2
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 5179,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0,
                        "email": "$USER@$DOMAIN"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 8001
                    },
                    {
                        "alpn": "h2",
                        "dest": 8002
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "$DOMAIN",
                    "alpn": [
                        "h2",
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
            "protocol": "freedom",
            "tag": "direct"
        }
    ]
}
VLESS2

# [VLESS] TCP-WS
cat >/usr/local/etc/v2ray/vless-tcp-ws.json <<-VLESS3
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 5428,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0,
                        "email": "$USER@$DOMAIN"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "/websocket"
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
VLESS3

cat >/etc/nginx/conf.d/vless-tcp-tls.conf <<-NGINX
server {
    listen 127.0.0.1:8001;
    listen 127.0.0.1:8002 http2;
    server_name $DOMAIN www.$DOMAIN;
    charset utf-8;

    location / {
        root /usr/share/nginx/html;
    }
    error_page  404 /404.html;
    error_page 500 502 503 504 /50x.html;
}
NGINX

# [VMESS] HTTP2-TLS
cat >/usr/local/etc/v2ray/vmess-http.json <<-VMESS1
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 6045,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {
                "network": "http",
                "security": "tls",
                "tlsSettings": {
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
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
VMESS1

# [VMESS] TCP-TLS
cat >/usr/local/etc/v2ray/vmess-tcp-tls.json <<-VMESS2
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 6137,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
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
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
VMESS2

# [VMESS] WS-TLS
cat >/usr/local/etc/v2ray/vmess-ws-tls.json <<-VMESS3
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 6273,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "tlsSettings": {
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
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
VMESS3

rm -f ~/v2ray.sh
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${YELLOW}  Name${CLR}:${GREEN} v2ray.sh                                  ${CLR}"
echo -e "${YELLOW}  Desc${CLR}:${GREEN} Script to install v2ray automatic         ${CLR}"
echo -e "${YELLOW}  Auth${CLR}:${GREEN} Doctype <cybertizedevel@gmail.com>        ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
sleep 3
