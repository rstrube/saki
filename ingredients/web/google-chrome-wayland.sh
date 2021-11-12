#!/bin/bash
#|#./ingredients/web/google-chrome-wayland.sh #Native Wayland Support for Google Chrome [Requires /web/google-chrome ingredient]

cat <<EOT > "chrome-flags.conf"	
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOT

cp chrome-flags.conf ~/.config/
rm chrome-flags.conf
