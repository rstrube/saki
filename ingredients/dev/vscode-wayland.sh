#!/bin/bash
#|#./ingredients/dev/vscode-wayland.sh #Native Wayland Support for VSCode [Requires /dev/1_vscode ingredient]

DIR=$(dirname "$0")
source $DIR/_helper/_vscode-functions.sh

# Copy the system .desktop file to your $HOME and tweak it to launch VSCode as a native Wayland application
if [[ ! -d "~/.local/share/applications" ]]; then
    mkdir -p ~/.local/share/applications
fi
cp /usr/share/applications/visual-studio-code.desktop ~/.local/share/applications/.
sed -i 's/\/usr\/bin\/code/& --enable-features=UseOzonePlatform --ozone-platform=wayland/' ~/.local/share/applications/visual-studio-code.desktop
