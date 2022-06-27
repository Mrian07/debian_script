#!/bin/bash

if [[ ! -d /usr/local/cybertize/helper ]]; then
  mkdir -p /usr/local/cybertize/helper
fi

if [[ ! -f /usr/local/cybertize/helper/color.sh ]]; then
  wget -q https://raw.githubusercontent.com/cybertize/axis/default/sources/helper/color.sh \
  -O /usr/local/cybertize/helper/color.sh
fi
if [[ ! -f /usr/local/cybertize/helper/function.sh ]]; then
  wget -q https://raw.githubusercontent.com/cybertize/axis/default/sources/helper/function.sh \
  -O /usr/local/cybertize/helper/function.sh
fi
if [[ ! -f /usr/local/cybertize/helper/utility.sh ]]; then
  wget -q https://raw.githubusercontent.com/cybertize/axis/default/sources/helper/utility.sh \
  -O /usr/local/cybertize/helper/utility.sh
fi

source /etc/os-release
source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

function check_init() {
  check_virtual
  check_shell
  check_kernel
  check_distro
  check_tun
  check_root
}
check_init

echo
echo -e "${RED}=====================================================${CLR}"
echo -e "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo -e "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo -e "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo -e "${RED}=====================================================${CLR}"
echo

add-shell /bin/false
add-shell /usr/bin/false
add-shell /usr/sbin/nologin

timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

apt-get -qq update
apt-get -yqq dist-upgrade
apt-get -yqq install build-essential
apt-get -yqq install automake
apt-get -yqq install cmake
apt-get -yqq install curl
apt-get -yqq install git
apt-get -yqq install zip
apt-get -yqq install jq
apt-get -yqq install speedtest-cli

echo "deb http://ftp.debian.org/debian buster-backports main" >/etc/apt/sources.list.d/buster-backports.list
apt-get -qq update

wget -q 'https://raw.githubusercontent.com/cybertize/axis/default/sources/banner' \
-O /etc/update-motd.d/10-uname

wget -q 'https://raw.githubusercontent.com/cybertize/axis/default/sources/message' \
-O /etc/issue.net

getIPV4=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIPV4}\"" >/usr/local/cybertize/.environment

getISP=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.isp')
echo "PROVIDER=${getISP}" >> /usr/local/cybertize/.environment

getContinent=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.continent_name')
echo "CONTINENT=${getContinent}" >> /usr/local/cybertize/.environment

getLocation=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.country_name')
echo "LOCATION=${getLocation}" >> /usr/local/cybertize/.environment

read -p " Sila masukkan nama Domain: " getDomain
echo "DOMAIN=\"${getDomain}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan Alamat emel: " getEmail
echo "EMAIL=\"${getEmail}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Negara: " getCountry
echo "COUNTRY=\"${getCountry}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Negeri: " getState
echo "STATE=\"${getState}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Daerah: " getRegion
echo "REGION=\"${getRegion}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Organisasi: " getOrg
echo "ORG=\"${getOrg}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Unit organisasi: " getUnit
echo "UNIT=\"${getUnit}\"" >>/usr/local/cybertize/.environment

read -p " Sila masukkan nama Samaran: " getName
echo "NAME=\"${getName}\"" >>/usr/local/cybertize/.environment

wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/nginx.sh \
&& chmod +x nginx.sh && ./nginx.sh 
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/dropbear.sh \
&& chmod +x dropbear.sh && ./dropbear.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/openvpn.sh \
&& chmod +x openvpn.sh && ./openvpn.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/squid.sh \
&& chmod +x squid.sh && ./squid.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/stunnel.sh \
&& chmod +x stunnel.sh && ./stunnel.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/badvpn.sh \
&& chmod +x badvpn.sh && ./badvpn.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/fail2ban.sh \
&& chmod +x fail2ban.sh && ./fail2ban.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/ddosdef.sh \
&& chmod +x ddosdef.sh && ./ddosdef.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/iptables.sh \
&& chmod +x iptables.sh && ./iptables.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/plugins/command.sh \
&& chmod +x command.sh && ./command.sh

# delete install.sh file
rm ~/install.sh

echo
echo "====================================================="
echo "    Tahniah, kami telah selesai dengan pemasangan    "
echo "     pada pelayan anda. Jangan lupa untuk reboot     "
echo "         sistem pelayan anda terlebih dahulu         "
echo "====================================================="
echo "= title:         install.sh                         ="
echo "= description:   Base script for setup server       ="
echo "= author:        Doctype (cybertize.ml)             ="
echo "= created:       May 19 2022                        ="
echo "====================================================="
echo
