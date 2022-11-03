#!/bin/bash

[[ "$USER" != root ]] && exit 1

function add-user() {
	clear
	echo -e "Add Xray User"
	echo -e "-------------"
	read -p "Username : " user
	if grep -qw "$user" /donb/xray/xray-clients.txt; then
		echo -e ""
		echo -e "User '$user' already exist."
		echo -e ""
		exit 0
	fi
	read -r -p "Duration (day) : " duration

	uuid=$(uuidgen)
	exp=$(date -d +"$duration" days +"%F")
	expired=$(date -d "$exp" +"%F")
	domain=$(cat /usr/local/etc/xray/domain)
	email=${user}@${domain}
	echo -e "${user}\t${uuid}\t${exp}" >> /donb/xray/xray-clients.txt

	cat /usr/local/etc/xray/config.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /usr/local/etc/xray/config_tmp.json
	mv -f /usr/local/etc/xray/config_tmp.json /usr/local/etc/xray/config.json
	cat /usr/local/etc/xray/config.json | jq '.inbounds[1].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /usr/local/etc/xray/config_tmp.json
	mv -f /usr/local/etc/xray/config_tmp.json /usr/local/etc/xray/config.json
	service xray restart

	clear
	echo -e "-------------------------------"
	echo -e " XRay Vless Account Information"
	echo -e "-------------------------------"
	echo -e "Host : $domain"
	echo -e "Username : $user"
	echo -e "Telco : Umobile / Digi"
	echo -e "Validity : day"
	echo -e "Expired date : $expired"
	echo -e "-------------------------------"
	echo -e "XRAY Config Information"
	echo -e ""
	echo -e ""
	echo -e "Link Digi    : vless://$uuid@vault21.digi.com.my.$domain:443?headerType=none&type=tcp&encryption=none&flow=xtls-rprx-splice&security=xtls&sni=vault21.digi.com.my#vless_xtls_Digi_$user"
	echo -e ""
	echo -e "Link Umobile : vless://$uuid@music.u.com.my.$domain:443?headerType=none&type=tcp&encryption=none&flow=xtls-rprx-splice&security=xtls&sni=clubopen.pubgmobile.com.music.u.com.my#vless_xtls_Umobile_$user"
	
}
