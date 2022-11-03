#!/bin/bash

[[ "$USER" != root ]] && exit 1

clear && echo
echo "====================================================="
echo " Begin wireguard package installation                "
echo "====================================================="

rm -f ~/wireguard.sh
echo "====================================================="
echo " Name: wireguard.sh                                  "
echo " Desc: Script to install wireguard automatic         "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5