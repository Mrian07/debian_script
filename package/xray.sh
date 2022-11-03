#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin xray package installation                     "
echo "====================================================="

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
USER=$(grep -sw 'USERNAME' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASS=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
UUID=$(grep -sw 'UUID' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
rm /usr/local/etc/xray/config.json

if [[ ! -f /usr/local/etc/xray/accounts ]]; then
    touch /usr/local/etc/xray/accounts
fi

certbot certonly --register-unsafely-without-email --agree-tos --standalone -d xray.cybertize.tk --cert-name xray
cp /etc/letsencrypt/live/xray/fullchain.pem /usr/local/etc/xray/fullchain.crt
cp /etc/letsencrypt/live/xray/privkey.pem /usr/local/etc/xray/private.key

chmod 644 /usr/local/etc/xray/fullchain.crt
chmod 644 /usr/local/etc/xray/private.key

# [TROJAN] TCP-TLS
cat >/usr/local/etc/xray/trojan-tcp-xtls.json <<-TROJAN1
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
TROJAN1

# [TROJAN] TCP-XTLS
cat >/usr/local/etc/xray/trojan-tcp-xtls.json <<-TROJAN2
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
                            "keyFile": "/usr/local/etc/xray/private.key",
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
TROJAN2

# [VLESS] TCP-GRPC
cat >/usr/local/etc/xray/vless-tcp-grpc.json <<-VLESS1
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "/dev/shm/Xray-VLESS-gRPC.socket,0666",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "grpc",
                "grpcSettings": {
                    "serviceName": ""
                }
            }
        }
    ],
    "outbounds": [
        {
            "tag": "direct",
            "protocol": "freedom",
            "settings": {}
        },
        {
            "tag": "blocked",
            "protocol": "blackhole",
            "settings": {}
        }
    ],
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "blocked"
            }
        ]
    }
}
VLESS1

# [VLESS] TCP-TLS
cat >/usr/local/etc/xray/vless-tcp-tls <<-VLESS2
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 443,
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
            "protocol": "freedom",
            "tag": "direct"
        }
    ]
}
VLESS2

# [VLESS] TCP-TLS-WS
cat >/usr/local/etc/xray/vless-tls-ws <<-VLESS3
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 443,
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
                        "dest": 80
                    },
                    {
                        "path": "/websocket",
                        "dest": 1234,
                        "xver": 1
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
VLESS3

# [VMESS] TCP-TLS-HTTP2
cat >/usr/local/etc/xray/vmess-tls-http <<-VMESS1
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
            "port": 1234,
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
cat >/usr/local/etc/xray/vmess-tcp-tls <<-VMESS2
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
            "port": 1234,
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

# [VMESS] TCP-WS
cat >/usr/local/etc/xray/vmess-tcp-ws <<-VMESS3
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
            "port": 1234,
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
                "security": "none"
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

# [VMESS] TCP-TLS-WS
cat >/usr/local/etc/xray/vmess-tls-ws <<-VMESS4
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
            "port": 1234,
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
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
VMESS4

systemctl enable xray@trojan-tcp-tls
systemctl enable xray@trojan-tcp-xtls

systemctl enable xray@vless-tcp-grpc
systemctl enable xray@vless-tcp-tls
systemctl enable xray@vless-tls-ws

systemctl enable xray@vmess-tls-http
systemctl enable xray@vmess-tcp-tls
systemctl enable xray@vmess-tcp-ws
systemctl enable xray@vmess-tls-ws

rm -f ~/xray.sh
echo "====================================================="
echo " Name: xray.sh                                       "
echo " Desc: Script to install xray automatic              "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5