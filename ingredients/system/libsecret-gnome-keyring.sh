#!/bin/bash
#|#./ingredients/system/libsecret-gnome-keyring.sh #Add support for libsecret via Gnome keyring (use until KWallet has libsecret support)

paru -S --noconfirm --needed gnome-keyring seahorse

if [[ ! -d "~/.config/autostart" ]]; then
    mkdir -p ~/.config/autostart
fi
cp /etc/xdg/autostart/{gnome-keyring-secrets.desktop,gnome-keyring-ssh.desktop} ~/.config/autostart/.
sed -i '/^OnlyShowIn.*$/d' ~/.config/autostart/gnome-keyring-secrets.desktop
sed -i '/^OnlyShowIn.*$/d' ~/.config/autostart/gnome-keyring-ssh.desktop
