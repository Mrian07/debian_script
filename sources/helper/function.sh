#!/bin/bash

check_virtual() {
  if [ -f /proc/user_beancounters ]; then
    echo "OpenVZ VPS tidak disokong!"
  fi
}

check_shell() {
  if readlink /proc/$$/exe | grep -q "dash"; then
    echo "Skrip perlu dijalankan dengan bash!" && exit
  fi
}

check_kernel() {
  if [[ $(uname -r | cut -d "." -f 1) -eq 2 ]]; then
    echo "Sistem menjalankan kernel lama." && exit
  fi
}

check_distro() {
  if [[ $ID == "debian" ]]; then
    debianVersion=$(grep -ws 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
    if [[ $debianVersion -ne 10 ]]; then
      echo "Versi Debian anda tidak disokong!" && exit
    fi
  else
    echo "Skrip boleh digunakan untuk Linux Debian sahaja!" && exit
  fi
}

check_tun() {
  if [[ ! -e /dev/net/tun ]]; then
    echo "Sistem ini tidak mempunyai peranti TUN yang tersedia." && exit
  fi
}

check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "Skrip perlu dijalankan dengan keistimewaan superuser." && exit
  fi
}
