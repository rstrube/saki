#!/bin/bash
#|#./ingredients/icons/papirus-icons.sh #Papirus icon theme

paru -S --noconfirm --needed papirus-icon-theme

# Configure KDE to use the Papirus icon theme
/usr/lib/plasma-changeicons "Papirus-Dark"
