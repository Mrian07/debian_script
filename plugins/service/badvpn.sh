#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

getID=$(grep -ws 'ID' /etc/os-release | cut -d '=' -f 2)
if [[ $getID == "debian" ]]; then
    getVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
    if [[ $getVersion -ne 10 ]]; then
        echo -e "${RED}Versi Debian anda tidak disokong!${CLR}" && exit 1
    fi
else
    echo -e "${RED}Skrip hanya untuk Linux Debian sahaja!${CLR}" && exit 1
fi

function configure {
    getPort=$(grep 'ExecStart' /etc/systemd/system/badvpn-udpgw.service | awk '{print $3}' | cut -d ':' -f 2)
    clear && echo
    echo "Secara lalai badvpn-udpgw menggunakan port $getPort"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPort
            if [[ -n $readPort && $readPort =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPort" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo "Port sudah digunakan!" && sleep 1
                    read -r -p "Masukkan port baharu: " readPort
                fi

                systemctl stop badvpn-udpgw
                sed -i "s|$getPort|$readPort|g" /etc/systemd/system/badvpn-udpgw.service
                systemctl start badvpn-udpgw
            fi
            echo "Perubahan telah dibuat" && break
        ;;
        [Nn]) _menu && break ;;
        esac
    done
}

function detail {
    getServiceName=$(systemctl show badvpn-udpgw.service -p Names | cut -d '=' -f 2)
    getServiceDesc=$(systemctl show badvpn-udpgw.service -p Description | cut -d '=' -f 2)
    isServiceActive=$(systemctl is-active badvpn-udpgw.service)
    isServiceEnable=$(systemctl is-enabled badvpn-udpgw.service)
    getServicePort=$(ps aux | pgrep 'badvpn-udpgw' | awk '{print $13}' | head -n 1 | cut -d ':' -f 2)

    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} Name   ${CLR}:${GREEN} $getServiceName${CLR}"
    echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $getServiceDesc${CLR}"
    echo -e "${YELLOW} Status ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} Ports  ${CLR}:${GREEN} $getServicePort${CLR}"
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

if [[ -f /usr/local/bin/badvpn-udpgw ]]; then
    _menu || install
fi