#!/bin/bash
#|#./ingredients/themes/dracula-theme-vscode.sh #Dracula theme for VSCode [Requires /dev/1_vscode ingredient]

DIR=$(dirname "$0")
source $DIR/../dev/_helper/_vscode-functions.sh

code --install-extension dracula-theme.theme-dracula
sed -i '$i\    "workbench.colorTheme": "Dracula",' "$VSCODE_SETTINGS_FILE_PATH"
