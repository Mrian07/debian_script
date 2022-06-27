#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

clear && echo
echo "==========================================="
echo "SENARAI AKAUN PENGGUNA"
echo "-------------------------------------------"
getNames=($(grep -sw 'client' /etc/passwd | cut -d : -f 1))
for user in ${getNames[@]}; do
  getExpDate="$(chage -l $user | grep "Account expires" | awk -F": " '{print $2}')"
  printf "%-15s %2s\n" "$user" "$getExpDate"
done
getTotal=${#getNames[@]}
echo
echo "JUMLAH : $getTotal pengguna"
echo "-------------------------------------------"
echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
echo "==========================================="
echo
