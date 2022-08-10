#!/bin/bash

function extend-user() {
	clear
	echo -e "Extend Xray User"
	echo -e "----------------"
	read -p "Username : " user
	if ! grep -qw "$user" /donb/xray/xray-clients.txt; then
		echo -e ""
		echo -e "User '$user' does not exist."
		echo -e ""
		exit 0
	fi
	read -p "Duration (day) : " extend

	uuid=$(cat /donb/xray/xray-clients.txt | grep -w $user | awk '{print $2}')
	exp_old=$(cat /donb/xray/xray-clients.txt | grep -w $user | awk '{print $3}')
	diff=$((($(date -d "${exp_old}" +%s)-$(date +%s))/(86400)))
	duration=$(expr $diff + $extend + 1)
	exp_new=$(date -d +${duration}days +%Y-%m-%d)
	exp=$(date -d "${exp_new}" +"%d %b %Y")

	sed -i "/\b$user\b/d" /donb/xray/xray-clients.txt
	echo -e "$user\t$uuid\t$exp_new" >> /donb/xray/xray-clients.txt

	clear
	echo -e "Success Extend Xray User Information"
	echo -e "------------------------------------"
	echo -e "Username : $user"
	echo -e "Expired date : $exp"
	echo -e "Additional day : $extend day"
	echo -e "Server : $domain"
	echo -e "------------------------------------"
	echo -e ""
}