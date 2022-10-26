#!/bin/bash

[[ "$USER" != root ]] && exit 1

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx

apt-get update
apt-get install nginx
apt-get install certbot
apt-get install python3-certbot

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

cat >/etc/nginx/nginx.conf <<-NGINX
user nginx;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
    multi_accept on;
    use epoll;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    #ssl_prefer_server_ciphers on;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types *;

    set_real_ip_from 173.245.48.0/20;
    set_real_ip_from 103.21.244.0/22;
    set_real_ip_from 103.22.200.0/22;
    set_real_ip_from 103.31.4.0/22;
    set_real_ip_from 141.101.64.0/18;
    set_real_ip_from 108.162.192.0/18;
    set_real_ip_from 190.93.240.0/20;
    set_real_ip_from 188.114.96.0/20;
    set_real_ip_from 197.234.240.0/22;
    set_real_ip_from 198.41.128.0/17;
    set_real_ip_from 162.158.0.0/15;
    set_real_ip_from 104.16.0.0/13;
    set_real_ip_from 104.24.0.0/14;
    set_real_ip_from 172.64.0.0/13;
    set_real_ip_from 131.0.72.0/22;
    set_real_ip_from 2400:cb00::/32;
    set_real_ip_from 2606:4700::/32;
    set_real_ip_from 2803:f800::/32;
    set_real_ip_from 2405:b500::/32;
    set_real_ip_from 2405:8100::/32;
    set_real_ip_from 2a06:98c0::/29;
    set_real_ip_from 2c0f:f248::/32;

    real_ip_header CF-Connecting-IP;
    include /etc/nginx/conf.d/*.conf;
}
NGINX

cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old
cat >/etc/nginx/conf.d/default.conf <<-CONF
server {
    listen 8080;
    server_name $DOMAIN www.$DOMAIN;

    #access_log /var/log/nginx/access.log  main;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts\$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    location ~ /\.ht {
        deny  all;
    }
}
CONF

wget -q -O /usr/share/nginx/html/index.html "https://raw.githubusercontent.com/cybertize/debian/buster/sources/configs/nginx/index.html"

rm ~/nginx.sh
echo -e "====================================================="
echo
echo -e " Name: nginx.sh                                      "
echo -e " Desc: Script to install nginx automatic             "
echo -e " Auth: Doctype <cybertizedevel@gmail.com>            "
echo
echo -e "====================================================="
sleep 3