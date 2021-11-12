#!/bin/bash
#|#./ingredients/dev/vscode-wayland.sh #Native Wayland Support for VSCode [Requires /dev/1_vscode ingredient]

DIR=$(dirname "$0")
source $DIR/_helper/_vscode-functions.sh

# Copy the system .desktop file to your $HOME and tweak it to launch VSCode as a native Wayland application
cp /usr/share/applications/visual-studio-code.desktop ~/.local/share/applications/.
sed -i 's/\/opt\/visual-studio-code\/code/& --enable-features=UseOzonePlatform --ozone-platform=wayland/' ~/.local/share/applications/visual-studio-code.desktop

# Tweak VSCode settings to ensure that a custom titlebar is used.  Without this there will be no titlebar on Gnome + Wayland
sed -i '$i\    "window.titleBarStyle": "custom",' "$VSCODE_SETTINGS_FILE_PATH"
