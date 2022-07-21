#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

_center() {
  local len=$(echo $1 | wc -m)
  echo -e "\e[$(( ($(tput cols) - $len) / 2))G\e[37;1m $1 \e[0m"
  return 0
}

[[ -e /etc/os-release ]] && source /etc/os-release

if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

if [[ $ID == "debian" ]]; then
  debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
  if [[ $debianVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
fi

apt-get -qq update
apt-get -y -qq dist-upgrade
apt-get -y -qq install gnupg1 automake cmake
apt-get -y -qq install build-essential
apt-get -y -qq install zip curl git jq
apt-get -y -qq install vnstat speedtest-cli

# echo "deb http://ftp.debian.org/debian buster-backports main
# deb-src http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list

timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

add-shell /bin/false
add-shell /usr/bin/false
add-shell /usr/sbin/nologin

echo "kernel.printk = 4 4 1 7 
kernel.panic = 10 
kernel.sysrq = 0 
kernel.shmmax = 4294967296 
kernel.shmall = 4194304 
kernel.core_uses_pid = 1 
kernel.msgmnb = 65536 
kernel.msgmax = 65536 
vm.swappiness = 20 
vm.dirty_ratio = 80 
vm.dirty_background_ratio = 5 
fs.file-max = 2097152 
net.core.netdev_max_backlog = 262144 
net.core.rmem_default = 31457280 
net.core.rmem_max = 67108864 
net.core.wmem_default = 31457280 
net.core.wmem_max = 67108864 
net.core.somaxconn = 65535 
net.core.optmem_max = 25165824 
net.ipv4.neigh.default.gc_thresh1 = 4096 
net.ipv4.neigh.default.gc_thresh2 = 8192 
net.ipv4.neigh.default.gc_thresh3 = 16384 
net.ipv4.neigh.default.gc_interval = 5 
net.ipv4.neigh.default.gc_stale_time = 120 
net.ipv4.tcp_slow_start_after_idle = 0 
net.ipv4.ip_local_port_range = 1024 65000 
net.ipv4.ip_no_pmtu_disc = 1 
net.ipv4.route.flush = 1 
net.ipv4.route.max_size = 8048576 
net.ipv4.icmp_echo_ignore_broadcasts = 1 
net.ipv4.icmp_ignore_bogus_error_responses = 1 
net.ipv4.tcp_congestion_control = htcp 
net.ipv4.tcp_mem = 65536 131072 262144 
net.ipv4.udp_mem = 65536 131072 262144 
net.ipv4.tcp_rmem = 4096 87380 33554432 
net.ipv4.udp_rmem_min = 16384 
net.ipv4.tcp_wmem = 4096 87380 33554432 
net.ipv4.udp_wmem_min = 16384 
net.ipv4.tcp_max_tw_buckets = 1440000 
net.ipv4.tcp_tw_reuse = 1 
net.ipv4.tcp_max_orphans = 400000 
net.ipv4.tcp_window_scaling = 1 
net.ipv4.tcp_rfc1337 = 1 
net.ipv4.tcp_syncookies = 1 
net.ipv4.tcp_synack_retries = 1 
net.ipv4.tcp_syn_retries = 2 
net.ipv4.tcp_max_syn_backlog = 16384 
net.ipv4.tcp_timestamps = 1 
net.ipv4.tcp_sack = 1 
net.ipv4.tcp_fack = 1 
net.ipv4.tcp_ecn = 2 
net.ipv4.tcp_fin_timeout = 10 
net.ipv4.tcp_keepalive_time = 600 
net.ipv4.tcp_keepalive_intvl = 60 
net.ipv4.tcp_keepalive_probes = 10 
net.ipv4.tcp_no_metrics_save = 1 
net.ipv4.conf.all.accept_redirects = 0 
net.ipv4.conf.all.send_redirects = 0 
net.ipv4.conf.all.accept_source_route = 0 
net.ipv4.conf.all.rp_filter = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv4.ip_forward = 1 
net.core.default_qdisc = fq
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = bbr" > /etc/sysctl.conf
sysctl -p &>/dev/null

dd if=/dev/zero of=/swapfile bs=2048 count=1048576
chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >>/etc/fstab
# swapon --show && free -h

[[ ! -d /usr/local/cybertize ]] && mkdir -p /usr/local/cybertize

getIP=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIP}\"" >/usr/local/cybertize/environment

getISP=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.isp')
echo "PROVIDER=${getISP}" >> /usr/local/cybertize/environment

getContinent=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.continent_name')
echo "CONTINENT=${getContinent}" >> /usr/local/cybertize/environment

getLocation=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.country_name')
echo "LOCATION=${getLocation}" >> /usr/local/cybertize/environment

read -p " Sila masukkan nama Domain: " getDomain
echo "DOMAIN=\"${getDomain}\"" >>/usr/local/cybertize/environment

echo "" >/etc/motd
wget -q -O /etc/update-motd.d/10-uname 'https://raw.githubusercontent.com/cybertize/axis/dev/sources/banner'
wget -q -O /etc/issue.net 'https://raw.githubusercontent.com/cybertize/axis/dev/sources/message'

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/nginx.sh \
&& chmod +x nginx.sh && ./nginx.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh \
&& chmod +x dropbear.sh && ./dropbear.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/openvpn.sh \
&& chmod +x openvpn.sh && ./openvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/shadowsocks.sh \
&& chmod +x shadowsocks.sh && ./shadowsocks.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh \
&& chmod +x squid.sh && ./squid.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh \
&& chmod +x stunnel.sh && ./stunnel.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/badvpn.sh \
&& chmod +x badvpn.sh && ./badvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/firewall.sh \
&& chmod +x firewall.sh && ./firewall.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/plugins/command.sh \
&& chmod +x command.sh && ./command.sh

rm ~/install.sh
echo && clear
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