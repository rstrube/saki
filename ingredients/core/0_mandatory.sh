#!/bin/bash
#|./ingredients/core/0_mandatory.sh #Mandatory programs & utilities

sudo pacman -Syu --noconfirm --needed reflector rust

CWD=$(pwd)

git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si --noconfirm --needed

cd ${CWD}
rm -rf /tmp/paru
