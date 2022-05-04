#!/bin/bash
#|#./ingredients/web/firefox.sh #Firefox

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed firefox

echo -e "${YELLOW}Additional about:config tweaks worth considering:${NC}"
echo -e "${YELLOW}widget.use-xdg-desktop-portal.file-picker=1 : Use native file picker via XDG desktop portal${NC}"