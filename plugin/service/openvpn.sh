#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

function configure {
    getPortTCP=$(grep -w 'port' /etc/openvpn/tcp.conf | cut -d ' ' -f 2)
    clear && echo
    echo -e "${MAGENTA}Secara lalai openvpn menggunakan${CLR} ${GREEN}$getPortTCP${CLR} ${MAGENTA}untuk sambungan TCP${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortTCP
            if [[ -n $readPortTCP && $readPortTCP =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortTCP" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortTCP
                fi

                systemctl stop openvpn@tcp
                sed -i "s|${getPortTCP}|${readPortTCP}|g" /etc/openvpn/tcp.conf
                systemctl start openvpn@tcp
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    getPortTLS=$(grep -w 'port' /etc/openvpn/tls.conf | cut -d ' ' -f 2)
    clear && echo
    echo -e "${MAGENTA}Secara lalai openvpn menggunakan${CLR} ${GREEN}$getPortTLS${CLR} ${MAGENTA}untuk sambungan TLS${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortTLS
            if [[ -n $readPortTLS && $readPortTLS =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortTLS" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortTLS
                fi

                systemctl stop openvpn@tls
                systemctl stop stunnel4
                sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/openvpn/tls.conf
                sed -i "s|${getPortTLS}|${readPortTLS}|g" /etc/stunnel/tls.conf
                systemctl start openvpn@tls
                systemctl start stunnel4
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) _menu && break ;;
        esac
    done
}

function detail {
    unitName=$(systemctl show openvpn.service -p Names | cut -d '=' -f 2)
    unitDesc=$(systemctl show openvpn.service -p Description | cut -d '=' -f 2)
    isActiveTCP=$(systemctl is-active openvpn@tcp.service)
    isEnableTCP=$(systemctl is-enabled openvpn@tcp.service)
    isActiveTLS=$(systemctl is-active openvpn@tls.service)
    isEnableTLS=$(systemctl is-enabled openvpn@tls.service)
    isActiveOHP=$(systemctl is-active openvpn@ohp.service)
    isEnableOHP=$(systemctl is-enabled openvpn@ohp.service)
    servicePortTCP=$(grep -w 'port' /etc/openvpn/tcp.conf | cut -d ' ' -f 2)
    servicePortTLS=$(grep -w 'port' /etc/openvpn/tls.conf | cut -d ' ' -f 2)
    servicePortOHP=$(grep -w 'port' /etc/openvpn/ohp.conf | cut -d ' ' -f 2)

    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} Name        ${CLR}:${GREEN} $unitName${CLR}"
    echo -e "${YELLOW} Desc        ${CLR}:${GREEN} $unitDesc${CLR}"
    echo -e "${YELLOW} Status(tcp) ${CLR}:${GREEN} $isActiveTCP & $isEnableTCP${CLR}"
    echo -e "${YELLOW} Status(tls) ${CLR}:${GREEN} $isActiveTLS & $isEnableTLS${CLR}"
    echo -e "${YELLOW} Status(ohp) ${CLR}:${GREEN} $isActiveOHP & $isEnableOHP${CLR}"
    echo -e "${YELLOW} Ports       ${CLR}:${GREEN} $servicePortTCP(tcp) | $servicePortTLS(tls) | $servicePortOHP(ohp)${CLR}"
    echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
}

function _menu {
    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} [01]${CLR} ${GREEN}configure ${CLR}- Edit fail configurasi"
    echo -e "${YELLOW} [02]${CLR} ${GREEN}detail    ${CLR}- Tunjukkan butiran & status"
    echo -e "${YELLOW} [03]${CLR} ${GREEN}back      ${CLR}- Kembali ke menu utama"
    echo -e "${YELLOW} [00]${CLR} ${GREEN}quit      ${CLR}- Keluar dari menu"
    echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${WHITE}=======[${CLR} ${BLUE}SKRIP OLEH DOCTYPE, HAK CIPTA 2022.${CLR} ${WHITE}]=======${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    while true; do
        read -r -p "Masukkan pilihan anda: " readChoice
        case "$readChoice" in
        01 | configure) configure && break ;;
        02 | detail) detail && break ;;
        03 | back) _menu && break ;;
        00 | quit) exit 0 ;;
        *) _menu ;;
        esac
    done
}

if [[ -d /etc/openvpn ]]; then
    _menu
fi