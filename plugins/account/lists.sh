#!/bin/bash
[[ "${EUID}" -ne 0 ]] && exit 1 || clear

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
