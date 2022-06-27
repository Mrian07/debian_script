#!/bin/bash

_error() {
  echo -e "[\e[34;1m$(date +'%F')\e[0m] \e[37;1mERROR:\e[0m$1"
  return 0
}
_warning() {
  echo -e "[\e[34;1m$(date +'%F')\e[0m] \e[37;1mWARNING:\e[0m$1"
  return 0
}
_success() {
  echo -e "[\e[34;1m$(date +'%F')\e[0m] \e[37;1mSUCCESS:\e[0m $1"
  return 0
}

_message() {
  echo -ne "[\e[34;1m$(date +'%F')\e[0m] \e[37;1m$1\e[0m"
  return 0
}
_right() {
  local len=$(echo $1 | wc -m)
  echo -en "\e[$(($(tput cols) - $len))G\e[37;42;1m $1 \e[0m"
  return 0
}
_center() {
  local len=$(echo $1 | wc -m)
  echo -e "\e[$(( ($(tput cols) - $len) / 2))G\e[37;42;1m $1 \e[0m"
  return 0
}

_progress() {
  echo -en "\e[36;1m$1\e[0m"
  TERM_WIDTH=$(tput cols)
  for ((i=1; i< (($TERM_WIDTH - ${#1} - ${#2})); i++)){ echo -en "\e[37;1m-\e[0m"; }
  echo -e "\e[32;1m $2\e[0m"
}