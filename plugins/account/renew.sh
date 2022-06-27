#!/bin/bash
[[ "$UID" -ne 0 ]] && exit 1 || clear

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  grep -sw "${getUser}" /etc/passwd &>/dev/null
  if [[ "$?" -ne 0 ]]; then
    echo "Nama pengguna tidak hujud!" && exit
  fi
done

until [[ ! -z $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
  read -p "Masukkan Tempoh aktif (Hari): " getDuration
done
expDate=$(date -d "$getDuration days" +"%F")

passwd -u $getUser &>/dev/null
usermod -e $expDate $getUser &>/dev/null

clear && echo
echo "==========================================="
echo "PERBAHARUI AKAUN PENGGUNA"
echo "-------------------------------------------"
echo " Nama pengguna : $getUser"
echo " Tarikh luput  : $expDate"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
