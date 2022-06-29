#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CLR="\e[0m"

[[ -e /etc/os-release ]] && source /etc/os-release

if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

if [ -f /proc/user_beancounters ]; then
  echo -e "${RED}OpenVZ VPS tidak disokong!${CLR}" && exit 1
fi

if [[ $ID == "debian" ]]; then
  debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
  if [[ $debianVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip boleh digunakan untuk Linux Debian sahaja!${CLR}" && exit 1
fi

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
apt-get -yqq upgrade
apt-get -yqq install build-essential
apt-get -yqq install automake cmake
apt-get -yqq install zip curl git jq
apt-get -yqq install vnstat speedtest-cli

# echo "deb http://ftp.debian.org/debian buster-backports main" >/etc/apt/sources.list.d/buster-backports.list
# apt-get -qq update

[[ ! -d /usr/local/cybertize ]] && mkdir -p /usr/local/cybertize

getIP=$(hostname -I | cut -d ' ' -f 1)
echo "IPADDR=\"${getIP}\"" >/usr/local/cybertize/.environment

getISP=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.isp')
echo "PROVIDER=${getISP}" >> /usr/local/cybertize/.environment

getContinent=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.continent_name')
echo "CONTINENT=${getContinent}" >> /usr/local/cybertize/.environment

getLocation=$(curl -s https://json.geoiplookup.io/${getIP} | jq '.country_name')
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

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/nginx.sh
chmod +x nginx.sh && ./nginx.sh

wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/dropbear.sh
chmod +x dropbear.sh && ./dropbear.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/openvpn.sh
chmod +x openvpn.sh && ./openvpn.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/squid.sh
chmod +x squid.sh && ./squid.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/stunnel.sh
chmod +x stunnel.sh && ./stunnel.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/badvpn.sh
chmod +x badvpn.sh && ./badvpn.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/fail2ban.sh
chmod +x fail2ban.sh && ./fail2ban.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/ddosdef.sh
chmod +x ddosdef.sh && ./ddosdef.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/packages/iptables.sh
chmod +x iptables.sh && ./iptables.sh

# wget -q https://raw.githubusercontent.com/cybertize/axis/dev/plugins/command.sh
chmod +x command.sh && ./command.sh

# delete install.sh file
rm ~/install.sh

echo
echo -e "==========[${RED} CYBERTIZE SETUP SCRIPT V1.0.0 ${CLR}]=========="
echo -e "${GREEN}    Tahniah, kami telah selesai dengan pemasangan    ${CLR}"
echo -e "${GREEN}     pada pelayan anda. Jangan lupa untuk reboot     ${CLR}"
echo -e "${GREEN}         sistem pelayan anda terlebih dahulu         ${CLR}"
echo -e "-----------------------------------------------------"
echo -e "=${YELLOW} title${CLR} :         ${GREEN}install.sh                         ${GREEN}="
echo -e "=${YELLOW} description${CLR} :   ${GREEN}Bash script for setup server       ${GREEN}="
echo -e "=${YELLOW} author${CLR} :        ${GREEN}Doctype (cybertize.ml)             ${GREEN}="
echo -e "=${YELLOW} created${CLR} :       ${GREEN}May 19 2022                        ${GREEN}="
echo -e "=====[${RED} CREATED BY DOCTYPE, ALL RIGHT RESERVED. ${CLR}]====="
echo
