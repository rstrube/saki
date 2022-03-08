#!/bin/bash
#|#./ingredients/icons/0_papirus-icons.sh #Papirus icon theme

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed papirus-icon-theme

# Configure KDE to use the Papirus icon theme
# /usr/lib/plasma-changeicons "Papirus-Dark"

echo -e "${YELLOW}Warning: you will need to configure Papirus as your icon theme via settings.${NC}"
