#!/bin/bash
#|#./ingredients/themes/dracula-vscode.sh #Dracula theme for VSCode [Requires /dev/vscode ingredient]

DIR=$(dirname "$0")
source $DIR/../dev/_helper/_vscode-functions.sh

create_empty_vscode_settings_if_neccessary
code --install-extension dracula-theme.theme-dracula
sed -i '$i\    "workbench.colorTheme": "Dracula",' "$VSCODE_SETTINGS_FILE_PATH"
