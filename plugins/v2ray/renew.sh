#!/bin/bash

function extend-user() {
	clear
	echo -e "Extend V2Ray User"
	echo -e "-----------------"
	read -r -p "Username : " user
	if ! grep -qw "$user" /donb/v2ray/v2ray-clients.txt; then
		echo -e ""
		echo -e "User '$user' does not exist."
		echo -e ""
		exit 0
	fi
	read -r -p "Duration (day) : " extend

	uuid=$(grep -w "$user" /donb/v2ray/v2ray-clients.txt | awk '{print $2}')
	exp_old=$(grep -w "$user" /donb/v2ray/v2ray-clients.txt | awk '{print $3}')
	diff=$((($(date -d "${exp_old}" +%s) - $(date +%s)) / (86400)))
	duration=$((diff + extend + 1))
	exp_new=$(date -d +"${duration}"days +%Y-%m-%d)
	exp=$(date -d "${exp_new}" +"%d %b %Y")

	sed -i "/\b$user\b/d" /donb/v2ray/v2ray-clients.txt
	echo -e "$user\t$uuid\t$exp_new" >>/donb/v2ray/v2ray-clients.txt

	clear
	echo -e "V2Ray User Information"
	echo -e "----------------------"
	echo -e "Username : $user"
	echo -e "Expired date : $exp"
	echo -e ""
}