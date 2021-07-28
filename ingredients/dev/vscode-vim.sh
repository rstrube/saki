#!/bin/bash
#|#./ingredients/dev/vscode-vim.sh #vim extension for Visual Studio Code [Requires /dev/vscode ingredient]

DIR=$(dirname "$0")
source $DIR/_helper/_vscode-functions.sh

create_empty_vscode_settings_if_neccessary
code --install-extension vscodevim.vim
