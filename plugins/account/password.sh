#!/bin/bash
[[ "${EUID}" -ne 0 ]] && exit 1 || clear

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  grep -sw "${getUser}" /etc/passwd &>/dev/null
  if [[ "$?" -ne 0 ]]; then
    echo "Nama pengguna tidak hujud!" && exit
  fi
done

until [[ ! -z $getPass ]]; do
  read -p "Masukkan kata laluan: " getPass
done
echo -e "$getPass\n$getPass" | passwd $getUser &>/dev/null

clear && echo
echo "==========================================="
echo "GANTI KATA LALUAN"
echo "-------------------------------------------"
echo " Nama pengguna : $getUser"
echo " Kata laluan   : $getPass"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
