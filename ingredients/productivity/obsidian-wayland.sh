#!/bin/bash
#|#./ingredients/productivity/obsidian-wayland.sh #Configure Obsidian to run as a native Wayland application

function update_obsidian_desktop_file_for_wayland {

    # Copy the system .desktop file to your $HOME and tweak it to launch Obsidian as a native Wayland application
    if [[ ! -d "~/.local/share/applications" ]]; then
        mkdir -p ~/.local/share/applications
    fi

    cp /usr/share/applications/obsidian.desktop ~/.local/share/applications/.
    sed -i 's/\/usr\/bin\/obsidian/& --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland/' ~/.local/share/applications/obsidian.desktop
}

function create_and_configure_electron_flags_for_wayland {

    if [[ ! -d "~./config" ]]; then
        mkdir -p ~/.config
    fi

    cat <<EOT > "electron-flags.conf"	
--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer
--ozone-platform=wayland
EOT

    cp electron-flags.conf ~/.config/
    rm electron-flags.conf
}

update_obsidian_desktop_file_for_wayland
create_and_configure_electron_flags_for_wayland