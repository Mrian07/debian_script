#!/bin/bash

[[ "$USER" != root ]] && exit 1

export DEBIAN_FRONTEND=noninteractive
apt-get -y install libtomcrypt1 cryptsetup cryptsetup-initramfs
apt-get -y install dropbear
systemctl stop dropbear

cp /etc/default/dropbear /etc/default/dropbear.old
echo 'NO_START=0
DROPBEAR_PORT=1153
DROPBEAR_EXTRA_ARGS="-p 1359 -p 1638"
DROPBEAR_BANNER="/etc/issue.net"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536' >/etc/default/dropbear

rm ~/dropbear.sh
echo -e "====================================================="
echo
echo -e " Name: dropbear.sh                                   "
echo -e " Desc: Script to install dropbear automatic          "
echo -e " Auth: Doctype <cybertizedevel@gmail.com>            "
echo
echo -e "====================================================="
sleep 3