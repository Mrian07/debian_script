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
    tcpPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
    clear && echo
    echo -e "${MAGENTA}Secara lalai perkhidmatan dropbear mengunakan port${CLR} ${GREEN}$tcpPort${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
        case $getAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortTCP
            if [[ -n $readPortTCP && $readPortTCP =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i :"$readPortTCP" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortTCP
                fi

                systemctl stop dropbear
                sed -i "s|${tcpPort}|${readPortTCP}|g" /etc/default/dropbear
                systemctl start dropbear
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    tlsPort=$(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"')
    clear && echo
    echo -e "${MAGENTA}Secara lalai dropbear menggunakan${CLR} ${GREEN}$tlsPort${CLR} ${MAGENTA}untuk sambungan stunnel${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
        case $getAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortTLS
            if [[ -n $readPortTLS && $readPortTLS =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i :"$readPortTLS" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortTLS
                fi

                systemctl stop dropbear
                sed -i "s|${tlsPort}|${readPortTLS}|g" /etc/default/dropbear
                systemctl start dropbear
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) _menu && break ;;
        esac
    done
}

function detail {
    getServiceName=$(systemctl show dropbear.service -p Names | cut -d '=' -f 2)
    getServiceDesc=$(systemctl show dropbear.service -p Description | cut -d '=' -f 2)
    isServiceActive=$(systemctl is-active dropbear.service)
    isServiceEnable=$(systemctl is-enabled dropbear.service)
    defaultPort=$(grep -w 'DROPBEAR_PORT' /etc/default/dropbear | cut -d '=' -f 2)
    stunnelPort=($(grep -w '\-p' /etc/default/dropbear | cut -d ' ' -f 2 | tr -d '"'))

    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} Name    ${CLR}:${GREEN} $getServiceName${CLR}"
    echo -e "${YELLOW} Desc    ${CLR}:${GREEN} $getServiceDesc${CLR}"
    echo -e "${YELLOW} Status  ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} Ports   ${CLR}:${GREEN} ${defaultPort[0]} (default) | ${stunnelPort[1]} (stunnel)${CLR}"
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

if [[ -f /etc/default/dropbear ]];then
    _menu
fi