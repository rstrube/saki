#!/bin/bash
#|#./ingredients/dev/2_kde-vscode-wayland.sh #Native Wayland Support for VSCode [Requires /dev/1_vscode ingredient]

DIR=$(dirname "$0")
source $DIR/_helper/_vscode-functions.sh

create_and_configure_code_flags_for_wayland
