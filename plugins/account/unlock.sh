#!/bin/bash
[[ "$UID" -ne 0 ]] && exit 1 || clear

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  grep -sw "${getUser}" /etc/passwd &>/dev/null
  if [[ "$?" -ne 0 ]]; then
    echo "Nama pengguna tidak hujud!" && exit
  fi
done
passwd -u $getUser &>/dev/null

clear && echo
echo "==========================================="
echo "BUKA KUNCI AKAUN"
echo "-------------------------------------------"
echo " Berjaya buka kunci kata laluan"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
