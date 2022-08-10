#!/bin/bash

function user-monitor() {
	data=($(cat /donb/v2ray/v2ray-clients.txt | awk '{print $1}'))
	data2=($(netstat -anp | grep ESTABLISHED | grep tcp6 | grep v2ray | grep -w '80\|443' | awk '{print $5}' | cut -d: -f1 | sort | uniq))
	domain=$(cat /usr/local/etc/v2ray/domain)
	clear
	echo -e ""
	echo -e "========================="
	echo -e "   V2Ray Login Monitor"
	echo -e "-------------------------"
	for user in "${data[@]}"; do
		touch /tmp/ipv2ray.txt
		for ip in "${data2[@]}"; do
			total=$(cat /var/log/v2ray/access.log | grep -w ${user}@${domain} | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
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
	echo -e "========================="
	echo -e ""
}