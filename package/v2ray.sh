#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin v2ray package installation                    "
echo "====================================================="

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
USER=$(grep -sw 'USERNAME' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
PASS=$(grep -sw 'PASSWORD' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
UUID=$(grep -sw 'UUID' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
bash <(curl -sL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
rm /usr/local/etc/v2ray/config.json

if [[ ! -f /usr/local/etc/v2ray/accounts ]]; then
    touch /usr/local/etc/v2ray/accounts
fi

certbot certonly --register-unsafely-without-email --agree-tos --standalone -d v2ray.${DOMAIN} --cert-name v2ray
cp /etc/letsencrypt/live/v2ray/fullchain.pem /usr/local/etc/v2ray/fullchain.crt
cp /etc/letsencrypt/live/v2ray/privkey.pem /usr/local/etc/v2ray/private.key

chmod 644 /usr/local/etc/v2ray/fullchain.crt
chmod 644 /usr/local/etc/v2ray/private.key

cat >/usr/local/etc/v2ray/trojan.json <<-TROJAN
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
TROJAN

cat >/usr/local/etc/v2ray/vless.json <<-VLESS
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
        },
        {
            "protocol": "vless",
            "port": 443,
            "settings": {
                "decryption":"none",
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {
                "network": "kcp",
                "kcpSettings": {
                    "seed": "{{ seed }}"
                }
            }
        },
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
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        },
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
                "security": "tls",
                "tlsSettings": {
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
        },
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
                        "dest": 8001,
                        "xver": 1
                    },
                    {
                        "alpn": "h2",
                        "dest": 8002,
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "$USER@$DOMAIN",
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
        },
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
                        "dest": 8001,
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
                            "certificateFile": "/usr/local/etc/v2ray/fullchain.crt",
                            "keyFile": "/usr/local/etc/v2ray/private.key"
                        }
                    ]
                }
            }
        },
        {
            "port": 443,
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
        },
        {
            "protocol": "freedom",
            "tag": "direct"
        }
    ]

VLESS

cat >/usr/local/etc/v2ray/vmess.json <<-VMESS
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
                "tcpSettings": {
                    "header": {
                        "type": "http",
                        "response": {
                            "version": "1.1",
                            "status": "200",
                            "reason": "OK",
                            "headers": {
                                "Content-Type": [
                                    "application/octet-stream",
                                    "video/mpeg",
                                    "application/x-msdownload",
                                    "text/html",
                                    "application/x-shockwave-flash"
                                ],
                                "Transfer-Encoding": [
                                    "chunked"
                                ],
                                "Connection": [
                                    "keep-alive"
                                ],
                                "Pragma": "no-cache"
                            }
                        }
                    }
                },
                "security": "none"
            }
        },
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
                            "certificateFile": "/usr/local/etc/v2ray/fullchain.crt",
                            "keyFile": "/usr/local/etc/v2ray/private.key"
                        }
                    ]
                }
            }
        },
        {
            "protocol": "vmess",
            "port": 1234,
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {
                "network": "kcp",
                "kcpSettings": {
                    "seed": "{{ seed }}"
                }
            }
        },
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
                "network": "tcp"
            }
        },
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
                            "certificateFile": "/usr/local/etc/v2ray/fullchain.crt",
                            "keyFile": "/usr/local/etc/v2ray/private.key"
                        }
                    ]
                }
            }
        },
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
        },
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
        },
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
VMESS

cat >/etc/nginx/conf.d/vless.conf <<-NGINX
server {
    listen 127.0.0.1:8001;
    #listen 127.0.0.1:8002 http2;
    server_name $DOMAIN www.$DOMAIN;
    charset utf-8;

    location / {
        root /usr/share/nginx/html;
    }
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}

server {
    listen 127.0.0.1:8001 proxy_protocol;
    listen 127.0.0.1:8002 http2 proxy_protocol;
    server_name $DOMAIN www.$DOMAIN;

    set_real_ip_from 127.0.0.1;
    charset utf-8;
    #access_log logs/yourserver.access.log proxy;

    location / {
        root /usr/share/nginx/html;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}

server {
    listen unix:/dev/shm/default.sock proxy_protocol;
    listen unix:/dev/shm/h2c.sock http2 proxy_protocol;
    server_name _;
    root root /usr/share/nginx/html;
    set_real_ip_from 127.0.0.1;
    include /etc/nginx/default.d/*.conf;

    location / {
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
}
NGINX

systemctl enable v2ray@trojan
systemctl enable v2ray@vless
systemctl enable v2ray@vmess

rm -f ~/v2ray.sh
echo "====================================================="
echo " Name: v2ray.sh                                      "
echo " Desc: Script to install v2ray automatic             "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5
