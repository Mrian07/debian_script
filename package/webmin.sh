#!/bin/bash

[[ "$USER" != root ]] && exit 1

echo
echo "====================================================="
echo " Begin webmin package installation                   "
echo "====================================================="

apt-get -qq -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl

echo "deb https://download.webmin.com/download/repository sarge contrib" >/etc/apt/sources.list.d/webmin.list
wget https://download.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get -qq update && apt-get -y install webmin

rm -f ~/webmin.sh
echo "====================================================="
echo " Name: webmin.sh                                     "
echo " Desc: Script to install webmin automatic            "
echo " Auth: Doctype <cybertizedevel@gmail.com>            "
echo "====================================================="
sleep 5