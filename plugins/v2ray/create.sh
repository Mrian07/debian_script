#!/bin/bash

function add-user() {
	echo -e "Add V2Ray User"
	echo -e "--------------"
	read -r -p "Username : " user
	if grep -qw "$user" /donb/v2ray/v2ray-clients.txt; then
		echo -e "User '$user' already exist."
		exit 0
	fi
	read -r -p "Duration (day) : " duration

	uuid=$(uuidgen)
	exp=$(date -d +"${duration}"days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
	domain=$(cat /usr/local/etc/v2ray/domain)
	email=${user}@${domain}
	echo -e "${user}\t${uuid}\t${exp}" >>/donb/v2ray/v2ray-clients.txt

	cat /usr/local/etc/v2ray/ws-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 2,"email": "'${email}'"}]' >/usr/local/etc/v2ray/ws-tls_tmp.json
	mv -f /usr/local/etc/v2ray/ws-tls_tmp.json /usr/local/etc/v2ray/ws-tls.json

	cat /usr/local/etc/v2ray/ws.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 2,"email": "'${email}'"}]' >/usr/local/etc/v2ray/ws_tmp.json
	mv -f /usr/local/etc/v2ray/ws_tmp.json /usr/local/etc/v2ray/ws.json

	service v2ray@ws-tls restart
	service v2ray@ws restart

	clear
	echo -e "V2Ray User Information"
	echo -e "----------------------"
	echo -e "Username : $user"
	echo -e "Expired date : $expired"
	echo -e ""
}