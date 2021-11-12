#!/bin/bash
#|#./ingredients/web/firefox-wayland.sh #Native Wayland Support for Firefox [Requires /web/firefox ingredient]

if [[ ! -d "~/.local/share/applications" ]]; then
    mkdir -p ~/.local/share/applications
fi

# Copy the system .desktop file to your $HOME and tweak it to launch Firefox as a native Wayland application
cp /usr/share/applications/firefox.desktop ~/.local/share/applications/.
sed -i 's/Exec=/&env MOZ_ENABLE_WAYLAND=1 /' ~/.local/share/applications/firefox.desktop
