#!/bin/bash

source /usr/local/cybertize/helper/color.sh
source /usr/local/cybertize/helper/function.sh
source /usr/local/cybertize/helper/utility.sh

function installPkg {
  while true; do
    read -r -p "Teruskan dengan pemasangan semula? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      if [[ ! -d /etc/openvpn ]]; then
        wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/openvpn.sh && bash openvpn.sh
      fi
      systemctl stop openvpn
      apt-get -y purge --autoremove openvpn
      apt-get -qq autoclean
      wget -q https://raw.githubusercontent.com/cybertize/axis/default/packages/openvpn.sh && bash openvpn.sh
      ;;
    [Nn]) openvpnMenu && break ;;
    esac
  done
}

function uninstallPkg {
  while true; do
    read -r -p "Adakah anda pasti mahu menyahpasang openvpn? [Y/n] " readAnswer
    case $readAnswer in
    [Yy])
      apt-get -y purge --autoremove openvpn
      echo "Bersihkan & Keluarkan pakej openvpn" && exit 0
      ;;
    [Nn]) openvpnMenu && break ;;
    esac
  done
}

function configurePkg {
  getPortTCP=$(grep -w port /etc/openvpn/server-tcp.conf | cut -d ' ' -f 2)
  clear && echo
  echo "Secara lalai openvpn-tcp mengunakan port $getPortTCP"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortTCP
      if [[ ! -z $readPortTCP && $readPortTCP =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortTCP | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop openvpn@server-tcp
        sed -i "s|${getPortTCP}|${readPortTCP}|g" /etc/openvpn/server-tcp.conf
        systemctl start openvpn@server-tcp
        echo "Perubahan telah dibuat" && break
      else
        echo "Port tidak sah!" && break
      fi
      ;;
    [Nn])
      echo "Tiada perubahan dibuat" && break
      ;;
    esac
  done

  getPortTLS=$(grep -w port /etc/openvpn/server-tls.conf | cut -d ' ' -f 2)
  clear && echo
  echo "Secara lalai openvpn-tls mendengar pada port $getPortTLS"
  while true; do
    read -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
    case $readAnswer in
    [Yy])
      read -p "Masukkan port baharu: " readPortTLS
      if [[ ! -z $readPortTLS && $readPortTLS =~ ^[0-9]+$ ]]; then
        checkPort=$(lsof -i:$readPortTLS | wc -l)
        if [[ $checkPort -ne 0 ]]; then
          echo "Port sudah digunakan!" && break
        fi

        systemctl stop openvpn@server-tls && systemctl stop stunnel4
        sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/openvpn/server-tls.conf
        sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/stunnel/stunnel.conf
        systemctl start openvpn@server-tls
        systemctl start stunnel4
        echo "Perubahan telah dibuat" && break
      else
        echo "Port tidak sah!" && break
      fi
      ;;
    [Nn]) openvpnMenu && break ;;
    esac
  done
}

function detailPkg {
  local unitName=$(systemctl show openvpn.service -p Names | cut -d '=' -f 2)
  local unitDesc=$(systemctl show openvpn.service -p Description | cut -d '=' -f 2)
  local isActiveTCP=$(systemctl is-active openvpn@server-tcp.service)
  local isActiveTLS=$(systemctl is-active openvpn@server-tls.service)
  local isEnableTCP=$(systemctl is-enabled openvpn@server-tcp.service)
  local isEnableTLS=$(systemctl is-enabled openvpn@server-tls.service)
  local getPortTCP=$(grep -w 'port' /etc/openvpn/server-tcp.conf | cut -d ' ' -f 2)
  local getPortTLS=$(grep -w 'port' /etc/openvpn/server-tls.conf | cut -d ' ' -f 2)

  clear && echo
  echo "==========================================="
  echo "BUTIRAN PERKHIDMATAN OPENVPN"
  echo "-------------------------------------------"
  echo " Name        : $unitName"
  echo " Desc        : $unitDesc"
  echo " Status(tcp) : $isActiveTCP & $isEnableTCP"
  echo " Status(tls) : $isActiveTLS & $isEnableTLS"
  echo " Ports       : $getPortTCP(tcp) | $getPortTLS(tls)"
  echo "-------------------------------------------"
  echo "DICIPTA OLEH DOCTYPE, POWERED BY CYBERTIZE."
  echo "==========================================="
  echo
}

function openvpnMenu {
  clear && echo
  echo "==========================================="
  echo "MENU OPENVPN"
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
    *) openvpnMenu ;;
    esac
  done
}

[[ -d /etc/openvpn ]] && openvpnMenu || installPkg