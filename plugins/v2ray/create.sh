#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

if [[ "$USER" != root ]]; then
  echo -e "${RED}Skrip perlu dijalankan dengan root!${CLR}" && exit 1
fi

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
  getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  if [[ $getVersion -ne 10 ]]; then
    echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
  fi
else
  echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

IPADDR=$(grep -sw 'IPADDR' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
DOMAIN=$(grep -sw 'DOMAIN' /usr/local/cybertize/environment | cut -d '=' -f 2 | tr -d '"')
UUID=$(uuidgen)
LEVEL=$(shuf -i 1-99)

function _menu {
  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} [01]${CLR} ${GREEN}trojan    ${CLR}- Tambah klien untuk trojan"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}vless     ${CLR}- Tambah klien untuk vless"
  echo -e "${YELLOW} [03]${CLR} ${GREEN}vmess     ${CLR}- Tambah klien untuk vmess"
  echo -e "${YELLOW} [04]${CLR} ${GREEN}back      ${CLR}- Kembali ke menu utama"
  echo -e "${YELLOW} [00]${CLR} ${GREEN}quit      ${CLR}- Keluar dari menu"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  while true; do
    read -r -p "Masukkan pilihan anda: " readChoice
    case "$readChoice" in
    01 | trojan) trojan && break ;;
    02 | vless) vless && break ;;
    03 | vmess) vmess && break ;;
    04 | back) _menu && break ;;
    00 | quit) exit 0 ;;
    *) _menu ;;
    esac
  done
}

function trojan {
  until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
    read -r -p "Masukkan nama pengguna: " getUser
    if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
      echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
      read -r -p "Sila masukkan semula nama pengguna: " getUser
    fi
  done

  until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
    read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
  done
  expDate=$(date -d "$getDuration days" +"%F")

  echo "${getUser} ${PASSWORD} ${expDate}" >>/usr/local/etc/v2ray/accounts

  cat /usr/local/etc/v2ray/trojan-tcp-tls.json | jq '.inbounds[0].settings.clients += [{"password": "'${UUID}'","email": "'${getUser}@${DOMAIN}'"}]' >/usr/local/etc/v2ray/trojan-tcp-tls_tmp.json
  mv -f /usr/local/etc/v2ray/trojan-tcp-tls_tmp.json /usr/local/etc/v2ray/trojan-tcp-tls.json
  systemctl restart v2ray@trojan-tcp-tls

  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
  echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
  echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
  echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
  echo -e "${YELLOW}   Alamat emel${CLR}:${GREEN} $getUser@$DOMAIN${CLR}"
  echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
  echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
  echo -e "${WHITE}=====================================================${CLR}"
  echo
}

function vless {
  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} [01]${CLR} ${GREEN}Tambah akaun vless_grpc-tls${CLR}"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}Tambah akaun vless_tcp-tls${CLR}"
  echo -e "${YELLOW} [03]${CLR} ${GREEN}Tambah akaun vless_tcp-ws${CLR}"
  echo -e "${YELLOW} [04]${CLR} ${GREEN}Kembali ke menu v2ray${CLR}"
  echo -e "${YELLOW} [00]${CLR} ${GREEN}Keluar dari menu${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  while true; do
    read -r -p "Masukkan pilihan anda: " readAnswer
    case "$readAnswer" in
    01) 
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vless-grpc-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'","email": "'${getUser}@${DOMAIN}'"}]' >/usr/local/etc/v2ray/vless-grpc-tls_tmp.json
      mv -f /usr/local/etc/v2ray/vless-grpc-tls_tmp.json /usr/local/etc/v2ray/vless-grpc-tls.json
      systemctl restart v2ray@vless-grpc-tls

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}   Alamat emel${CLR}:${GREEN} $getUser@$DOMAIN${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    02)
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vless-tcp-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'","level": "'${LEVEL}'","email": "'${getUser}@${DOMAIN}'"}]' >/usr/local/etc/v2ray/vless-tcp-tls_tmp.json
      mv -f /usr/local/etc/v2ray/vless-tcp-tls_tmp.json /usr/local/etc/v2ray/vless-tcp-tls.json
      systemctl restart v2ray@vless-tcp-tls

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}   Alamat emel${CLR}:${GREEN} $getUser@$DOMAIN${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    03)
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vless-tcp-ws.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'","level": "'${LEVEL}'","email": "'${getUser}@${DOMAIN}'"}]' >/usr/local/etc/v2ray/vless-tcp-ws_tmp.json
      mv -f /usr/local/etc/v2ray/vless-tcp-ws_tmp.json /usr/local/etc/v2ray/vless-tcp-ws.json
      systemctl restart v2ray@vless-tcp-ws

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}   Alamat emel${CLR}:${GREEN} $getUser@$DOMAIN${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    04) _menu && break ;;

    00) exit 0 ;;

    *) _menu ;;
    esac
  done
}

function vmess {
  clear && echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  echo -e "${YELLOW} [01]${CLR} ${GREEN}Tambah akaun vmess_grpc-tls${CLR}"
  echo -e "${YELLOW} [02]${CLR} ${GREEN}Tambah akaun vmess_tcp-tls${CLR}"
  echo -e "${YELLOW} [03]${CLR} ${GREEN}Tambah akaun vmess_ws-tls${CLR}"
  echo -e "${YELLOW} [04]${CLR} ${GREEN}Kembali ke menu v2ray${CLR}"
  echo -e "${YELLOW} [00]${CLR} ${GREEN}Keluar dari menu${CLR}"
  echo
  echo -e "${WHITE}=====================================================${CLR}"
  echo
  while true; do
    read -r -p "Masukkan pilihan anda: " readAnswer
    case "$readAnswer" in
    01) 
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vmess-http-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'"}]' >/usr/local/etc/v2ray/vmess-http-tls_tmp.json
      mv -f /usr/local/etc/v2ray/vmess-http-tls_tmp.json /usr/local/etc/v2ray/vmess-http-tls.json
      systemctl restart v2ray@vmess-http-tls

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    02)
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vmess-tcp-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'"}]' >/usr/local/etc/v2ray/vmess-tcp-tls_tmp.json
      mv -f /usr/local/etc/v2ray/vmess-tcp-tls_tmp.json /usr/local/etc/v2ray/vmess-tcp-tls.json
      systemctl restart v2ray@vmess-tcp-tls

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    03)
      until [[ -n $getUser && $getUser =~ ^[a-zA-Z0-9_]+$ ]]; do
        read -r -p "Masukkan nama pengguna: " getUser
        if grep -sw "$getUser" /usr/local/etc/v2ray/accounts &>/dev/null; then
          echo -e "${RED}Nama pengguna sudah wujud!${CLR}"
          read -r -p "Sila masukkan semula nama pengguna: " getUser
        fi
      done

      until [[ -n $getDuration && $getDuration =~ ^[0-9]+$ ]]; do
        read -r -p "Masukkan Tempoh aktif (Hari): " getDuration
      done
      expDate=$(date -d "$getDuration days" +"%F")

      echo "${getUser} ${UUID} ${expDate}" >>/usr/local/etc/v2ray/accounts

      cat /usr/local/etc/v2ray/vmess-ws-tls.json | jq '.inbounds[0].settings.clients += [{"id": "'${UUID}'"}]' >/usr/local/etc/v2ray/vmess-ws-tls_tmp.json
      mv -f /usr/local/etc/v2ray/vmess-ws-tls_tmp.json /usr/local/etc/v2ray/vmess-ws-tls.json
      systemctl restart v2ray@vmess-ws-tls

      clear && echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
      echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
      echo -e "${YELLOW}     Alamat IP${CLR}:${GREEN} $IPADDR${CLR}"
      echo -e "${YELLOW}   Nama domain${CLR}:${GREEN} $DOMAIN${CLR}"
      echo -e "${YELLOW} Nama pengguna${CLR}:${GREEN} $getUser${CLR}"
      echo -e "${YELLOW}  Tempoh aktif${CLR}:${GREEN} $getDuration${CLR}"
      echo -e "${YELLOW}  Tarikh luput${CLR}:${GREEN} $expDate${CLR}"
      echo
      echo -e "${WHITE}=====================================================${CLR}"
      echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
      echo -e "${WHITE}=====================================================${CLR}"
      echo
    ;;

    04) _menu && break ;;

    00) exit 0 ;;

    *) _menu ;;
    esac
  done
}

_menu
