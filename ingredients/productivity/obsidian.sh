#!/bin/bash
#|#./ingredients/productivity/obsidian.sh #Excellent markdown based note manager and "second brain"

paru -S --noconfirm --needed obsidian

cat <<EOT > "electron-flags.conf"	
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOT

cp electron-flags.conf ~/.config/
rm electron-flags.conf
