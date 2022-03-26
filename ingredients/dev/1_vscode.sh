#!/bin/bash
#|#./ingredients/dev/1_vscode.sh #Visual Studio Code

DIR=$(dirname "$0")
source $DIR/_helper/_vscode-functions.sh

paru -S --noconfirm --needed visual-studio-code-bin

create_empty_vscode_settings_if_neccessary
