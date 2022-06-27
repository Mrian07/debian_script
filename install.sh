#!/bin/bash

echo
echo "====================================================="
echo "── █ █▀▀▀█ █▀▀▀ █─▄▀ █▀▀▀ █▀▀█ █▀▀▀█ █── █ █▀▀█ █▄─ █"
echo "▄─ █ █── █ █▀▀▀ █▀▄─ █▀▀▀ █▄▄▀ ▀▀▀▄▄ ─█ █─ █▄▄█ █ █ █"
echo "█▄▄█ █▄▄▄█ █▄▄▄ █─ █ █▄▄▄ █─ █ █▄▄▄█ ─▀▄▀─ █─── █──▀█"
echo "====================================================="
echo

[[ -f /etc/os-release ]] && source /etc/os-release || . /etc/os-release

if [[ $ID == "debian" ]]; then
  debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
  if [[ $debianVersion -ne 10 ]]; then
    echo "Your version of Debian is not supported!"
    exit 1
  fi
else
  echo "Script can be used for Linux Debian only"
  exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Script needs to be run with superuser privileges."
  exit 1
fi

timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

add-shell /bin/false
add-shell /usr/bin/false
add-shell /usr/sbin/nologin

echo 'deb http://ftp.debian.org/debian buster-backports main' >/etc/apt/sources.list.d/buster-backports.list

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essential
apt-get -y install cmake automake curl git zip jq speedtest

wget -q 'https://raw.githubusercontent.com/cybertize/axis/default/sources/banner' \
-O /etc/update-motd.d/10-uname

wget -q 'https://raw.githubusercontent.com/cybertize/axis/default/sources/message' \
-O /etc/issue.net

if [[ ! -d /usr/local/cybertize/utility ]]; then
  mkdir -p /usr/local/cybertize/utility
fi

getIPV4=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIPV4}\"" >/usr/local/cybertize/utility/.env

getISP=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.isp')
echo "PROVIDER=${getISP}" >> /usr/local/cybertize/utility/.env

getContinent=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.continent_name')
echo "CONTINENT=${getContinent}" >> /usr/local/cybertize/utility/.env

getLocation=$(curl -s https://json.geoiplookup.io/${getIPV4} | jq '.country_name')
echo "LOCATION=${getLocation}" >> /usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Domain: " getDomain
echo "DOMAIN=\"${getDomain}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan Alamat emel: " getEmail
echo "EMAIL=\"${getEmail}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Negara: " getCountry
echo "COUNTRY=\"${getCountry}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Negeri: " getState
echo "STATE=\"${getState}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Daerah: " getRegion
echo "REGION=\"${getRegion}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Organisasi: " getOrg
echo "ORG=\"${getOrg}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Unit organisasi: " getUnit
echo "UNIT=\"${getUnit}\"" >>/usr/local/cybertize/utility/.env

read -p " Sila masukkan nama Samaran: " getName
echo "NAME=\"${getName}\"" >>/usr/local/cybertize/utility/.env

wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/nginx.sh && bash nginx.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/dropbear.sh && bash dropbear.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/openvpn.sh && bash openvpn.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/squid.sh && bash squid.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/stunnel.sh && bash stunnel.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/badvpn.sh && bash badvpn.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/fail2ban.sh && bash fail2ban.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/ddosdeflate.sh && bash ddosdeflate.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/iptables.sh && bash iptables.sh
wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/command.sh && bash command.sh

apt-get autoclean -y && apt-get autocear -y
rm ~/setup.sh

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