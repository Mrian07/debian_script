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
    # ################################ #
    # TROJAN
    # ################################ #
    getPortTrojan=$(grep -w '"port":' /usr/local/etc/v2ray/trojan-tcp-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$getPortTrojan${CLR} ${MAGENTA}untuk sambungan trojan-tcp-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortTrojan
            if [[ -n $readPortTrojan && $readPortTrojan =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortTrojan" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortTrojan
                fi

                systemctl stop v2ray@trojan-tcp-tls
                sed -i "s|${getPortTrojan}|${readPortTrojan}|g" /etc/openvpn/default.conf
                systemctl start v2ray@trojan-tcp-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    # ################################ #
    # VLESS
    # ################################ #
    vlessGrpcTls=$(grep -w '"port":' /usr/local/etc/v2ray/vless-grpc-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$vlessGrpcTls${CLR} ${MAGENTA}untuk sambungan vless-grpc-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readVlessGrpcTls
            if [[ -n $readVlessGrpcTls && $readVlessGrpcTls =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readVlessGrpcTls" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readVlessGrpcTls
                fi

                systemctl stop v2ray@vless-grpc-tls
                sed -i "s|${vlessGrpcTls}|${readVlessGrpcTls}|g" /usr/local/etc/v2ray/vless-grpc-tls.json
                systemctl start v2ray@vless-grpc-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    vlessTcpTls=$(grep -w '"port":' /usr/local/etc/v2ray/vless-tcp-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$vlessTcpTls${CLR} ${MAGENTA}untuk sambungan vless-tcp-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readVlessTcpTls
            if [[ -n $readVlessTcpTls && $readVlessTcpTls =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readVlessTcpTls" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readVlessTcpTls
                fi

                systemctl stop v2ray@vless-tcp-tls
                sed -i "s|${vlessTcpTls}|${readVlessTcpTls}|g" /usr/local/etc/v2ray/vless-tcp-tls.json
                systemctl start v2ray@vless-tcp-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    vlessTcpWs=$(grep -w '"port":' /usr/local/etc/v2ray/vless-tcp-ws.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$vlessTcpWs${CLR} ${MAGENTA}untuk sambungan vless-tcp-ws${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readVlessTcpWs
            if [[ -n $readVlessTcpWs && $readVlessTcpWs =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readVlessTcpWs" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readVlessTcpWs
                fi

                systemctl stop v2ray@vless-tcp-ws
                sed -i "s|${vlessTcpWs}|${readVlessTcpWs}|g" /usr/local/etc/v2ray/vless-tcp-ws.json
                systemctl start v2ray@vless-tcp-ws
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    # ################################ #
    # VMESS
    # ################################ #
    getPortVmess=$(grep -w '"port":' /usr/local/etc/v2ray/vmess-http-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$getPortTrojan${CLR} ${MAGENTA}untuk sambungan vmess-http-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortVmess
            if [[ -n $readPortVmess && $readPortVmess =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortVmess" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortVmess
                fi

                systemctl stop v2ray@vmess-http-tls
                sed -i "s|${getPortVmess}|${readPortVmess}|g" /etc/openvpn/default.conf
                systemctl start v2ray@vmess-http-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    getPortVmess=$(grep -w '"port":' /usr/local/etc/v2ray/vmess-tcp-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$getPortTrojan${CLR} ${MAGENTA}untuk sambungan vmess-tcp-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortVmess
            if [[ -n $readPortVmess && $readPortVmess =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortVmess" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortVmess
                fi

                systemctl stop v2ray@vmess-tcp-tls
                sed -i "s|${getPortVmess}|${readPortVmess}|g" /etc/openvpn/default.conf
                systemctl start v2ray@vmess-tcp-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done

    getPortVmess=$(grep -w '"port":' /usr/local/etc/v2ray/vmess-ws-tls.json | cut -d ' ' -f 2 | tr -d ',')
    clear && echo
    echo -e "${MAGENTA}Secara lalai v2ray menggunakan${CLR} ${GREEN}$getPortTrojan${CLR} ${MAGENTA}untuk sambungan vmess-ws-tls${CLR}"
    while true; do
        read -r -p "Adakah anda mahu menukar port [Y/n]? " readAnswer
        case $readAnswer in
        [Yy])
            read -r -p "Masukkan port baharu: " readPortVmess
            if [[ -n $readPortVmess && $readPortVmess =~ ^[0-9]+$ ]]; then
                checkPort=$(lsof -i:"$readPortVmess" | wc -l)
                if [[ $checkPort -ne 0 ]]; then
                    echo -e "${RED}Port sudah digunakan!${CLR}"
                    read -r -p "Masukkan semula port baharu: " readPortVmess
                fi

                systemctl stop v2ray@vmess-ws-tls
                sed -i "s|${getPortVmess}|${readPortVmess}|g" /etc/openvpn/default.conf
                systemctl start v2ray@vmess-ws-tls
                echo -e "${GREEN}Perubahan telah dibuat${CLR}" && break
            fi
        ;;
        [Nn]) echo -e "${YELLOW}Tiada perubahan dibuat${CLR}" && break ;;
        esac
    done
}

function detail {
    getTrojanPort=$(grep -w 'port' /usr/local/etc/v2ray/trojan-tcp-tls.json | cut -d ' ' -f 2)

    getVlessGrpcTls=$(grep -w 'port' /usr/local/etc/v2ray/vless-grpc-tls.json | cut -d ' ' -f 2)
    getVlessTcpTls=$(grep -w 'port' /usr/local/etc/v2ray/vless-tcp-tls.json | cut -d ' ' -f 2)
    getVlessTcpWs=$(grep -w 'port' /usr/local/etc/v2ray/vless-tcp-ws.json | cut -d ' ' -f 2)

    getPortVmess=$(grep -w 'port' /usr/local/etc/v2ray/vmess-http-tls.json | cut -d ' ' -f 2)
    getPortVmess=$(grep -w 'port' /usr/local/etc/v2ray/vmess-tcp-tls.json | cut -d ' ' -f 2)
    getPortVmess=$(grep -w 'port' /usr/local/etc/v2ray/vmess-ws-tls.json | cut -d ' ' -f 2)

    clear && echo
    echo -e "${WHITE}=====================================================${CLR}"
    echo -e "${BLUE}░█▀▀█ ░█──░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ▀█▀ ░█▀▀▀█ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█─── ░█▄▄▄█ ░█▀▀▄ ░█▀▀▀ ░█▄▄▀ ─░█── ░█─ ─▄▄▄▀▀ ░█▀▀▀${CLR}"
    echo -e "${BLUE}░█▄▄█ ──░█── ░█▄▄█ ░█▄▄▄ ░█─░█ ─░█── ▄█▄ ░█▄▄▄█ ░█▄▄▄${CLR}"
    echo -e "${WHITE}=====================================================${CLR}"
    echo
    echo -e "${YELLOW} Name   ${CLR}:${GREEN} $getServiceName${CLR}"
    echo -e "${YELLOW} Desc   ${CLR}:${GREEN} $getServiceDesc${CLR}"

    echo -e "${MAGENTA}TROJAN${CLR}"
    echo -e "${YELLOW} TROJAN Status ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} TCP-TLS Port  ${CLR}:${GREEN} $getTrojanTcpTls${CLR}"

    echo -e "${MAGENTA}VLESS${CLR}"
    echo -e "${YELLOW} VLESS Status  ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} GRPC-TLS Port ${CLR}:${GREEN} $getVlessGrpcTls${CLR}"
    echo -e "${YELLOW} TCP-TLS Port  ${CLR}:${GREEN} $getVlessTcpTls${CLR}"
    echo -e "${YELLOW} WS-TCP Port   ${CLR}:${GREEN} $getVlessTcpWs${CLR}"

    echo -e "${MAGENTA}VMESS${CLR}"
    echo -e "${YELLOW} VMESS Status  ${CLR}:${GREEN} $isServiceActive & $isServiceEnable${CLR}"
    echo -e "${YELLOW} HTTP-TLS Port ${CLR}:${GREEN} $getVmessHttpTls${CLR}"
    echo -e "${YELLOW} TCP-TLS Port  ${CLR}:${GREEN} $getVmessTcpTls${CLR}"
    echo -e "${YELLOW} WS-TLS Port   ${CLR}:${GREEN} $getVmessWsTls${CLR}"
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