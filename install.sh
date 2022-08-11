#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -s 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
  getVersion=$(grep -s 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  if [[ $getVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

apt-get -qq update
apt-get -y -qq dist-upgrade

timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

apt-get -y -qq install build-essential
apt-get -y -qq install gnupg1 automake cmake
apt-get -y -qq install software-properties-common
apt-get -y -qq install apt-show-versions
apt-get -y -qq install zip curl git jq lsof
apt-get -y -qq install vnstat speedtest-cli

echo "deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt-get update -qq
apt-get -y install rng-tools
echo "HRNGDEVICE=/dev/urandom" >>/etc/default/rng-tools
systemctl restart rng-tools &>/dev/null

apt-get install certbot -y
apt-get install python3-certbot -y
apt-get install python3-certbot-nginx -y
# apt-get install python3-certbot-apache -y

echo "/bin/false
/usr/bin/false
/usr/sbin/nologin" >>/etc/shells

echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv4.ip_forward = 1
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr" >/etc/sysctl.conf
sysctl -p &>/dev/null

dd if=/dev/zero of=/swapfile bs=2048 count=1048576
chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >>/etc/fstab

# /etc/systemd/resolved.conf
echo "[Resolve]
DNS=76.76.2.117 76.76.2.118
FallbackDNS=dns.google
Domains=cybertize.tk www.cybertize.tk
#LLMNR=yes
#MulticastDNS=yes
#DNSSEC=allow-downgrade
#DNSOverTLS=yes
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes" >/etc/systemd/resolved.conf

[[ ! -d /usr/local/cybertize ]] && mkdir -p /usr/local/cybertize/plugins

getIP=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIP}\"" >/usr/local/cybertize/environment

getISP=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.isp')
echo "PROVIDER=${getISP}" >> /usr/local/cybertize/environment

getContinent=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.continent_name')
echo "CONTINENT=${getContinent}" >> /usr/local/cybertize/environment

getLocation=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.country_name')
echo "LOCATION=${getLocation}" >> /usr/local/cybertize/environment

read -r -p "Sila masukkan nama Domain: " getDomain
echo "DOMAIN=\"${getDomain}\"" >>/usr/local/cybertize/environment

echo "" >/etc/motd
wget -q -O /etc/update-motd.d/10-uname 'https://raw.githubusercontent.com/cybertize/debian/buster/sources/banner'
wget -q -O /etc/issue.net 'https://raw.githubusercontent.com/cybertize/debian/buster/sources/message'

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/nginx.sh \
&& chmod +x nginx.sh && ./nginx.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/dropbear.sh \
&& chmod +x dropbear.sh && ./dropbear.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/openvpn.sh \
&& chmod +x openvpn.sh && ./openvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/libev.sh \
&& chmod +x libev.sh && ./libev.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/v2ray.sh \
&& chmod +x v2ray.sh && ./v2ray.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/xray.sh \
&& chmod +x xray.sh && ./xray.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/wireguard.sh \
&& chmod +x wireguard.sh && ./wireguard.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/squid.sh \
&& chmod +x squid.sh && ./squid.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/ohpserver.sh \
&& chmod +x ohpserver.sh && ./ohpserver.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/websocket.sh \
&& chmod +x websocket.sh && ./websocket.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/stunnel.sh \
&& chmod +x stunnel.sh && ./stunnel.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/badvpn.sh \
&& chmod +x badvpn.sh && ./badvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/firewall.sh \
&& chmod +x firewall.sh && ./firewall.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/packages/webmin.sh \
&& chmod +x webmin.sh && ./webmin.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/plugins/command.sh \
&& chmod +x command.sh && ./command.sh

rm ~/install.sh
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo
echo -e "${GREEN}    Tahniah, kami telah selesai dengan pemasangan    ${CLR}"
echo -e "${GREEN}     pada pelayan anda. Jangan lupa untuk reboot     ${CLR}"
echo -e "${GREEN}         sistem pelayan anda terlebih dahulu         ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
