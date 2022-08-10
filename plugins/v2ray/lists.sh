#!/bin/bash

function user-list() {
	clear
	echo -e ""
	echo -e "==============================="
	echo -e "Username          Exp. Date"
	echo -e "-------------------------------"
	while read expired; do
		user=$(echo $expired | awk '{print $1}')
		exp=$(echo $expired | awk '{print $3}')
		exp_date=$(date -d"${exp}" "+%d %b %Y")
		printf "%-17s %2s\n" "$user" "$exp_date"
	done </donb/v2ray/v2ray-clients.txt
	total=$(wc -l /donb/v2ray/v2ray-clients.txt | awk '{print $1}')
	echo -e "-------------------------------"
	echo -e "Total accounts: $total"
	echo -e "==============================="
	echo -e ""
}