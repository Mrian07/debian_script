#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
    echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
    getVersion=$(grep -s 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
    if [[ $getVersion -ne 10 ]]; then
        echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
else
    echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essential
apt-get -y install gnupg1 automake cmake
apt-get -y install software-properties-common
apt-get -y install apt-show-versions
apt-get -y install zip curl git jq lsof
apt-get -y install certbot python3-certbot
apt-get -y install vnstat speedtest-cli
apt-get -y install uuid-runtime
apt-get -y install rng-tools
echo "HRNGDEVICE=/dev/urandom" >>/etc/default/rng-tools
systemctl restart rng-tools

echo "deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt-get update

echo "/bin/false
/usr/bin/false
/usr/sbin/nologin" >>/etc/shells

echo "fs.file-max = 51200

net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
# net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_mtu_probing = 1
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr" >/etc/sysctl.conf
sysctl -p &>/dev/null

# /etc/systemd/resolved.conf
echo "[Resolve]
DNS=76.76.2.117 76.76.2.118
FallbackDNS=dns.google
#Domains=cybertize.tk www.cybertize.tk
#LLMNR=yes
MulticastDNS=yes
#DNSSEC=allow-downgrade
#DNSOverTLS=yes
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes" >/etc/systemd/resolved.conf

echo "#
# /etc/security/limits.conf
#

* soft nofile 51200
* hard nofile 51200

root soft nofile 51200
root hard nofile 51200

# End of file" >/etc/security/limits.conf

echo "# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

export LS_OPTIONS='--color=auto'
alias ls='ls \$LS_OPTIONS'
alias ll='ls \$LS_OPTIONS -l'
alias la='ls \$LS_OPTIONS -la'

ulimit -n 51200" >~/.bashrc

dd if=/dev/zero of=/swapfile bs=2048 count=1048576
chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >>/etc/fstab

[[ ! -d /usr/local/cybertize ]] && mkdir -p /usr/local/cybertize/plugins

getIP=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIP}\"" >/usr/local/cybertize/environment

getISP=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.isp')
echo "PROVIDER=${getISP}" >>/usr/local/cybertize/environment

getContinent=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.continent_name')
echo "CONTINENT=${getContinent}" >>/usr/local/cybertize/environment

getLocation=$(curl -s https://json.geoiplookup.io/"${getIP}" | jq '.country_name')
echo "LOCATION=${getLocation}" >>/usr/local/cybertize/environment

read -r -p "Masukkan nama Domain: " getDomain
echo "DOMAIN=\"${getDomain}\"" >>/usr/local/cybertize/environment

read -r -p "Masukkan nama pengguna: " getUser
echo "USERNAME=\"${getUser}\"" >>/usr/local/cybertize/environment

read -r -p "Masukkan kata laluan: " getPass
echo "PASSWORD=\"${getPass}\"" >>/usr/local/cybertize/environment

getUUID=$(uuidgen)
echo "UUID=\"${getUUID}\"" >>/usr/local/cybertize/environment

expDate=$(date -d "365 days" +"%F")

useradd "$getUser"
usermod -c "admin" "$getUser"
usermod -s /bin/false "$getUser"
usermod -e "$expDate" "$getUser"
echo -e "$getPass\n$getPass" | passwd "$getUser" &>/dev/null

echo "" >/etc/motd
wget -q -O /etc/update-motd.d/10-uname 'https://raw.githubusercontent.com/cybertize/debian/buster/sources/banner'
wget -q -O /etc/issue.net 'https://raw.githubusercontent.com/cybertize/debian/buster/sources/message'

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/nginx.sh \
&& chmod +x nginx.sh && ./nginx.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/dropbear.sh \
&& chmod +x dropbear.sh && ./dropbear.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/openvpn.sh \
&& chmod +x openvpn.sh && ./openvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/libev.sh \
&& chmod +x libev.sh && ./libev.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/v2ray.sh \
&& chmod +x v2ray.sh && ./v2ray.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/xray.sh \
&& chmod +x xray.sh && ./xray.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/wireguard.sh \
&& chmod +x wireguard.sh && ./wireguard.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/squid.sh \
&& chmod +x squid.sh && ./squid.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/ohpserver.sh \
&& chmod +x ohpserver.sh && ./ohpserver.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/websocket.sh \
&& chmod +x websocket.sh && ./websocket.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/stunnel.sh \
&& chmod +x stunnel.sh && ./stunnel.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/badvpn.sh \
&& chmod +x badvpn.sh && ./badvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/package/firewall.sh \
&& chmod +x firewall.sh && ./firewall.sh

wget -q https://raw.githubusercontent.com/cybertize/debian/buster/plugins/command.sh \
&& chmod +x command.sh && ./command.sh

rm ~/install.sh
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
echo -e "${GREEN}    Tahniah, kami telah selesai dengan pemasangan    ${CLR}"
echo -e "${GREEN}     pada pelayan anda. Jangan lupa untuk reboot     ${CLR}"
echo -e "${GREEN}         sistem pelayan anda terlebih dahulu         ${CLR}"
echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo
