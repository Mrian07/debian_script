#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

data=($(cat /usr/local/etc/v2ray/accounts | awk '{print $1}'))
data2=($(netstat -anp | grep ESTABLISHED | grep tcp6 | grep v2ray | grep -w '80\|443' | awk '{print $5}' | cut -d: -f1 | sort | uniq))
domain=$(cat /usr/local/etc/v2ray/domain)

clear && echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo

for user in "${data[@]}"; do
	touch /tmp/ipv2ray.txt
	for ip in "${data2[@]}"; do
		total=$(cat /var/log/v2ray/access.log | grep -w "${user}@${domain}" | awk '{print $3}' | cut -d: -f1 | grep -w "$ip" | sort | uniq)
		if [[ "$total" == "$ip" ]]; then
			echo -e "$total" >>/tmp/ipv2ray.txt
		fi
	done
	total=$(cat /tmp/ipv2ray.txt)
	if [[ -n "$total" ]]; then
		total2=$(cat /tmp/ipv2ray.txt | nl)
		echo -e "$user :"
		echo -e "$total2"
	fi
	rm -f /tmp/ipv2ray.txt
done

echo
echo -e "${WHITE}=====================================================${CLR}"
echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
echo -e "${WHITE}=====================================================${CLR}"
echo