#!/bin/bash
#|#./ingredients/fonts/kde-fonts.sh #Install and configure sane fonts for KDE

DIR=$(dirname "$0")
source $DIR/_helper/_font-common-functions.sh

install_fonts
setup_local_fontconfig

# Set the default fixed with font for KDE to JetBrains Mono 11pt
kwriteconfig5 --group General --key fixed "JetBrains Mono,11,-1,5,50,0,0,0,0,0"

test_coverage
