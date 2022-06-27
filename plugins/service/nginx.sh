#!/bin/bash
[[ "$UID" -ne 0 ]] && exit 1 || clear

function installPkg {
  while true; do
    read -p "Teruskan dengan pemasangan semula? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      if [[ ! -f /etc/nginx/nginx.conf ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/nginx.sh \
        && chmod +x nginx.sh && ./nginx.sh
      fi
      systemctl stop nginx
      apt-get -y -qq --autoremove purge nginx
      wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/nginx.sh \
      && chmod +x nginx.sh && ./nginx.sh
      ;;
    [Nn]) nginxMenu && break ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -p "Adakah anda pasti mahu menyahpasang nginx? (Y/n) " getAnswer
    case $getAnswer in
    [Yy])
      systemctl stop nginx
      apt-get -y -qq --autoremove purge nginx
      echo "Bersihkan & Keluarkan pakej nginx" && exit 0
      ;;
    [Nn]) nginxMenu && break ;;
    esac
  done
}

function configurePkg {
  getPort=($(netstat -tlpn | grep nginx | grep -w 'tcp' | awk '{print $4}' | cut -d ':' -f 2))
  clear && echo
  echo "Secara lalai nginx mengunakan port ${getPort[1]} untuk sambungan HTTP"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baru untuk HTTP: " readPortHTTP
      if [[ ! -z $readPortHTTP && $readPortHTTP =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortHTTP | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop nginx
        sed -i "s|${getPort[1]}|${readPortHTTP}|g" /etc/nginx/sites-enabled/default
        systemctl start nginx
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn]) echo "Tiada perubahan dibuat" && break ;;
    esac
  done

  clear && echo
  echo "Secara lalai nginx mengunakan port ${getPort[0]} untuk sambungan HTTPS"
  while true; do
    read -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
    case $getAnswer in
    [Yy])
      read -p "Masukkan port baru untuk HTTPS: " readPortHTTPS
      if [[ ! -z $readPortHTTPS && $readPortHTTPS =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortHTTPS | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop nginx
        sed -i "s|${getPort[0]}|${readPortHTTPS}|g" /etc/nginx/sites-enabled/default
        systemctl start nginx
        echo "Perubahan telah dibuat" && break
      fi
      ;;
    [Nn]) nginxMenu && break ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show nginx.service -p Names | cut -d '=' -f 2)
  local unitDesc="A high performance web server"
  local isActive=$(systemctl is-active nginx.service)
  local isEnable=$(systemctl is-enabled nginx.service)
  local getPorts=($(netstat -tlpn | grep nginx | grep -w 'tcp' | awk '{print $4}' | cut -d ':' -f 2))

  clear && echo
  echo "==========================================="
  echo "BUTIRAN PERKHIDMATAN NGINX"
  echo "-------------------------------------------"
  echo " Name   : $unitName"
  echo " Desc   : $unitDesc"
  echo " Status : $isActive & $isEnable"
  echo " Ports  : ${getPorts[1]}(http) | ${getPorts[0]}(https"
  echo "-------------------------------------------"
  echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
  echo "==========================================="
  echo
}

function nginxMenu {
  clear && echo
  echo "==========================================="
  echo "MENU NGINX"
  echo "-------------------------------------------"
  echo " [01] reinstall - Pemasangan semula pakej"
  echo " [02] uninstall - Menyahpasang pakej"
  echo " [03] configure - Edit fail konfigurasi"
  echo " [04] detail    - Tunjukkan butiran & status"
  echo " [05] back      - Kembali ke menu utama"
  echo " [00] quit      - Keluar dari menu"
  echo "-------------------------------------------"
  echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
  echo "==========================================="
  echo
  while true; do
    read -p "Masukkan pilihan anda: " readChoice
    case "$readChoice" in
    01 | reinstall) installPkg && break ;;
    02 | uninstall) uninstallPkg && break ;;
    03 | configure) configurePkg && break ;;
    04 | detail) detailPkg && break ;;
    05 | back) menu && break ;;
    00 | quit) exit 0 ;;
    *) nginxMenu ;;
    esac
  done
}

[[ -f /etc/nginx/nginx.conf ]] && nginxMenu || installPkg
