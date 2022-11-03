#!/bin/bash

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
MAGENTA="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
CLR="\e[0m"

[[ "$USER" != root ]] && exit 1

function configure {

}

function detail {
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

function menu {
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