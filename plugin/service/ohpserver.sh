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
    getPortDropbear=$(grep 'ExecStart' /etc/systemd/system/ohpserver-dropbear.service | awk '{print $3}')
    clear && echo
    echo -e "${MAGENTA}Secara lalai ohpserver mengunakan port${CLR} ${GREEN}$getPortDropbear${CLR} ${MAGENTA}untuk sambungan dropbear${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
        case $getAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortDropbear
            if [[ -n $readPortDropbear && $readPortDropbear =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i :"$readPortDropbear" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortDropbear
                fi

                systemctl stop ohpserver-dropbear
                sed -i "s|${getPortDropbear}|${readPortDropbear}|g" /etc/systemd/system/ohpserver-dropbear.service
                systemctl start ohpserver-dropbear
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    getPortOpenvpn=$(grep 'ExecStart' /etc/systemd/system/ohpserver-openvpn.service | awk '{print $3}')
    clear && echo
    echo -e "${MAGENTA}Secara lalai ohpserver menggunakan${CLR} ${GREEN}$getPortOpenvpn${CLR} ${MAGENTA}untuk sambungan openvpn${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port (Y/n)? " getAnswer
        case $getAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortOpenvpn
            if [[ -n $readPortOpenvpn && $readPortOpenvpn =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i :"$readPortOpenvpn" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortOpenvpn
                fi

                systemctl stop dropbear
                sed -i "s|${getPortOpenvpn}|${readPortOpenvpn}|g" /etc/systemd/system/ohpserver-openvpn.service
                systemctl start dropbear
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) _menu && break ;;
        esac
    done
}

function detail {
    getServiceName=$(systemctl show ohpserver-dropbear.service -p Names | cut -d '=' -f 2)
    getServiceDesc=$(systemctl show ohpserver-dropbear.service -p Description | cut -d '=' -f 2)
    isServiceActive=$(systemctl is-active ohpserver-dropbear.service)
    isServiceEnable=$(systemctl is-enabled ohpserver-dropbear.service)
    isServiceActive=$(systemctl is-active ohpserver-openvpn.service)
    isServiceEnable=$(systemctl is-enabled ohpserver-openvpn.service)
    PortForDropbear=$(grep 'ExecStart' /etc/systemd/system/ohpserver-dropbear.service | awk '{print $3}')
    PortForOpenvpn=$(grep 'ExecStart' /etc/systemd/system/ohpserver-openvpn.service | awk '{print $3}')

    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} Name    ${CLR}:${GREEN} $getServiceName${CLR}"
    echo -e "${YELLOW} Desc    ${CLR}:${GREEN} $getServiceDesc${CLR}"
    echo -e "${YELLOW} OHP Dropbear Status  ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} OHP OpenVPN Status  ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} OHP Dropbear Port   ${CLR}:${GREEN} $PortForDropbear (ohp-dropbear)${CLR}"
    echo -e "${YELLOW} OHP OpenVPN Port   ${CLR}:${GREEN} $PortForOpenvpn (ohp-openvpn)${CLR}"
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

if [[ -f /usr/local/bin/ohpserver ]]; then
    _menu
fi