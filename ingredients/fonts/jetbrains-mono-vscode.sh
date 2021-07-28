#!/bin/bash
#|#./ingredients/fonts/jetbrains-mono-vscode.sh #JetBrains Mono font for Visual Studio Code [Requires /dev/vscode and /fonts/enhanced-fonts ingredients]


DIR=$(dirname "$0")
source $DIR/../dev/_helper/_vscode-functions.sh

create_empty_vscode_settings_if_neccessary

echo "Updating VSCode settings.json file with font configuration..."

sed -i '$i\    "editor.fontFamily": "JetBrains Mono",' "$VSCODE_SETTINGS_FILE_PATH"
sed -i '$i\    "editor.fontWeight": "500",' "$VSCODE_SETTINGS_FILE_PATH"
sed -i '$i\    "editor.fontLigatures": true,' "$VSCODE_SETTINGS_FILE_PATH"
