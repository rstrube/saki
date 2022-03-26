#!/bin/bash
#|#./ingredients/icons/0_kde-papirus-icons.sh #Papirus icon theme and config for KDE

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed papirus-icon-theme

# Configure KDE to use the Papirus icon theme
/usr/lib/plasma-changeicons "Papirus-Dark"
