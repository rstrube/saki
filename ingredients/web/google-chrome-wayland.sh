#!/bin/bash
#|#./ingredients/web/google-chrome-wayland.sh #Native Wayland Support for Google Chrome [Requires /web/google-chrome ingredient]

if [[ ! -d "~./config" ]]; then
    mkdir -p ~/.config
fi

cat <<EOT > "chrome-flags.conf"	
--enable-features=WebRTCPipeWireCapturer
--ozone-platform-hint=auto
EOT

cp chrome-flags.conf ~/.config/
rm chrome-flags.conf
