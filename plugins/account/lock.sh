#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

until [[ ! -z $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "Masukkan nama pengguna: " getUser
  grep -sw "${getUser}" /etc/passwd &>/dev/null
  if [[ "$?" -ne 0 ]]; then
    echo "Nama pengguna tidak hujud!" && exit
  fi
done
passwd -l $getUser &>/dev/null

clear && echo
echo "==========================================="
echo "KUNCI AKAUN PENGGUNA"
echo "-------------------------------------------"
echo " Berjaya mengunci kata laluan"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
