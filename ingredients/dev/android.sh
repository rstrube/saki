#!/bin/bash
#|#./ingredients/dev/android.sh #Android development tools (ADB, etc.)

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed android-tools android-udev 

# Add user to the correct groups
sudo usermod -a -G adbusers $USER

echo -e "${YELLOW}Warning: you will need to reboot in order for the configuration changes to take affect.${NC}"
