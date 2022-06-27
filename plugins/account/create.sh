#!/bin/bash
[[ "$UID" -ne 0 ]] && exit 1 || clear

DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/utility/.env | cut -d '=' -f 2 | tr -d '"')

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  if grep -sw "$getUser" /etc/passwd &>/dev/null; then
    echo "Nama pengguna sudah wujud!" && exit
  fi
done

until [[ ! -z $getPass ]]; do
  read -p "Masukkan kata laluan: " getPass
done

until [[ ! -z $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
  read -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

useradd $getUser
usermod -c "client" $getUser
usermod -s /bin/false $getUser
usermod -e $expDate $getUser
echo -e "$getPass\n$getPass" | passwd $getUser &>/dev/null

clear && echo
echo "==========================================="
echo "BUAT AKAUN PENGGUNA"
echo "-------------------------------------------"
echo " Nama pengguna: $getUser"
echo " Kata laluan: $getPass"
echo " Tarikh luput: $expDate"
echo " https://$DOMAIN/client-tcp.ovpn"
echo " https://$DOMAIN/client-tls.ovpn"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
