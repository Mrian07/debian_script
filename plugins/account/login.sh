#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

clear && echo
echo "==========================================="
echo "LOG MASUK KLIEN"
echo "-------------------------------------------"
cat "/var/log/auth.log" | grep -i dropbear | grep -i "Password auth succeeded" >/tmp/acclogin.txt
cat /tmp/acclogin.txt | grep "dropbear\[$sid\]" >/tmp/serviceid.txt
getUser=$(cat /tmp/serviceid.txt | awk '{print $10}')
getAddr=$(cat /tmp/serviceid.txt | awk '{print $12}')
getSID=($(ps aux | grep -i dropbear | awk '{print $2}'))
if [[ "${#getSID[@]}" -gt 0 ]]; then
	echo "$sid $getUser $getAddr"
else
	echo "Tiada pengguna log masuk"
fi

echo
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
	cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' >/tmp/vpn-login-tcp.txt
	cat /tmp/vpn-login-tcp.txt
fi
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
