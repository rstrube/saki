#!/bin/bash
#|#./ingredients/productivity/obsidian-wayland.sh #Configure Obsidian to run as a native Wayland application

if [[ ! -d "~./config" ]]; then
    mkdir -p ~/.config
fi

cat <<EOT > "electron-flags.conf"	
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOT

cp electron-flags.conf ~/.config/
rm electron-flags.conf
