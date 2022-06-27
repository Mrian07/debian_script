#!/bin/bash
[[ "${EUID}" -ne 0 ]] && exit 1 || clear

echo
echo "==========================================="
echo "MENU UTAMA"
echo "-------------------------------------------"
echo " [01] ➟ Tambah akaun pengguna"
echo " [02] ➟ Perbaharui akaun pengguna"
echo " [03] ➟ Senarai pengguna log masuk"
echo " [04] ➟ Senaraikan semua pengguna"
echo " [05] ➟ Ganti kata laluan pengguna"
echo " [06] ➟ Nyadayakan akaun pengguna"
echo " [07] ➟ Dayakan akaun pengguna"
echo " [08] ➟ Padam akaun pengguna"
echo
echo " [09] ➟ Menu perkhidmatan Nginx"
echo " [10] ➟ Menu perkhidmatan Dropbear"
echo " [11] ➟ Menu perkhidmatan OpenVPN"
echo " [12] ➟ Menu perkhidmatan Squid"
echo " [13] ➟ Menu perkhidmatan Stunnel"
echo " [14] ➟ Menu perkhidmatan BadVPN"
echo " [15] ➟ Uji kelajuan pelayan"
echo " [00] ➟ Keluar dari menu"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo

read -p "Masukkan pilihan anda: " getChoice
case $getChoice in
# dropbear
01) bash /usr/local/cybertize/create.sh ;;
02) bash /usr/local/cybertize/renew.sh ;;
03) bash /usr/local/cybertize/login.sh ;;
04) bash /usr/local/cybertize/lists.sh ;;
05) bash /usr/local/cybertize/password.sh ;;
06) bash /usr/local/cybertize/lock.sh ;;
07) bash /usr/local/cybertize/unlock.sh ;;
08) bash /usr/local/cybertize/delete.sh ;;
09) bash /usr/local/cybertize/nginx.sh ;;
10) bash /usr/local/cybertize/dropbear.sh ;;
11) bash /usr/local/cybertize/openvpn.sh ;;
12) bash /usr/local/cybertize/squid.sh ;;
13) bash /usr/local/cybertize/stunnel.sh ;;
14) bash /usr/local/cybertize/badvpn.sh ;;
15) speedtest ;;

00) clear && exit 0 ;;
*) menu ;;
esac
