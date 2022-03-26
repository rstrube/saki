#!/bin/bash
#|#./ingredients/fonts/vscode-jetbrains-mono.sh #JetBrains Mono font for Visual Studio Code [Requires /dev/1_vscode and /fonts/0_xxx-fonts ingredients]

sed -i '$i\    "editor.fontFamily": "JetBrains Mono",' "$VSCODE_SETTINGS_FILE_PATH"
sed -i '$i\    "editor.fontWeight": "500",' "$VSCODE_SETTINGS_FILE_PATH"
sed -i '$i\    "editor.fontLigatures": true,' "$VSCODE_SETTINGS_FILE_PATH"
