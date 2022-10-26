#!/bin/bash

[[ "$USER" != root ]] && exit 1

rm -f ~/wireguard.sh
echo -e "====================================================="
echo
echo -e " Name: wireguard.sh                                  "
echo -e " Desc: Script to install wireguard automatic         "
echo -e " Auth: Doctype <cybertizedevel@gmail.com>            "
echo
echo -e "====================================================="
sleep 3