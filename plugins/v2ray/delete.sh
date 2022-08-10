#!/bin/bash

function delete-user() {
	clear
	echo -e "Delete V2Ray User"
	echo -e "-----------------"
	read -r -p "Username : " user
	echo -e ""
	if ! grep -qw "$user" /donb/v2ray/v2ray-clients.txt; then
		echo -e ""
		echo -e "User '$user' does not exist."
		echo -e ""
		exit 0
	fi
	uuid="$(grep -w "$user" /donb/v2ray/v2ray-clients.txt | awk '{print $2}')"

	cat /usr/local/etc/v2ray/ws-tls.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' >/usr/local/etc/v2ray/ws-tls_tmp.json
	mv -f /usr/local/etc/v2ray/ws-tls_tmp.json /usr/local/etc/v2ray/ws-tls.json
	cat /usr/local/etc/v2ray/ws.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' >/usr/local/etc/v2ray/ws_tmp.json
	mv -f /usr/local/etc/v2ray/ws_tmp.json /usr/local/etc/v2ray/ws.json
	sed -i "/\b$user\b/d" /donb/v2ray/v2ray-clients.txt
	service v2ray@ws-tls restart
	service v2ray@ws restart

	echo -e "User '$user' deleted successfully."
	echo -e ""
}