#!/bin/bash
# recipe.sh : 2022-06-20-10:34:25
# NOTE: Please uncomment the ingredients you wish to install before running!
# --------------------------------------------------------------------------

function main() {

# Shell
# --------------------------------------------------------------------------
#./ingredients/shell/fish.sh #Fish shell

# Filesystem
# --------------------------------------------------------------------------
#./ingredients/fs/android-mtp.sh #Android MTP (Media Transfer Protocol) Filesystem

# System
# --------------------------------------------------------------------------
#./ingredients/system/btop.sh #btop: a terminal based system monitoring tool (like htop but better)
#./ingredients/system/kde-configure-baloo-basic-indexing.sh #Configure Baloo file indexer to only perform basic indexing (performance improvement)
#./ingredients/system/kde-overview-and-shortcuts.sh #Enable new Plasma overview feature and set sane shortcuts
#./ingredients/system/libsecret-gnome-keyring.sh #Add support for libsecret via Gnome keyring (use until KWallet has libsecret support)

# Editors
# --------------------------------------------------------------------------
#./ingredients/editor/neovim.sh #Neovim (replaces vim)

# Web
# --------------------------------------------------------------------------
#./ingredients/web/firefox.sh #Firefox
#./ingredients/web/firefox-wayland.sh #Native Wayland Support for Firefox [Requires /web/firefox ingredient]
#./ingredients/web/google-chrome.sh #Google Chrome
#./ingredients/web/google-chrome-wayland.sh #Native Wayland Support for Google Chrome [Requires /web/google-chrome ingredient]
#./ingredients/web/remmina.sh #Remmina RDP client
#./ingredients/web/slack.sh #Slack

# Development
# --------------------------------------------------------------------------
#./ingredients/dev/0_git.sh "Firstname Lastname" "myname@mydomain.com" #Git installation and configuration
#./ingredients/dev/1_vscode.sh #Visual Studio Code
#./ingredients/dev/2_kde-vscode-wayland.sh #Native Wayland Support for VSCode [Requires /dev/1_vscode ingredient]
#./ingredients/dev/3_dotnet.sh #.NET Core SDK and Runtimes
#./ingredients/dev/4_dotnet-https-dev-cert.sh #ASP.NET Dev HTTPS Cert [Requires /dev/dotnet ingredient]
#./ingredients/dev/android.sh #Android development tools (ADB, etc.)
#./ingredients/dev/git-credential-manager-core.sh #Git Crendential Manager (.NET Core based)
#./ingredients/dev/postman.sh #Postman
#./ingredients/dev/vscode-vim.sh #vim extension for VSCode [Requires /dev/1_vscode ingredient]

# Productivity
# --------------------------------------------------------------------------
#./ingredients/productivity/cht.sh #cht.sh is a command line cheatsheet that provides TLDR for tons of things
#./ingredients/productivity/flameshot.sh #Flameshot (screenshot application)
#./ingredients/productivity/obsidian.sh #Excellent markdown based note manager and "second brain"
#./ingredients/productivity/obsidian-wayland.sh #Configure Obsidian to run as a native Wayland application
#./ingredients/productivity/pdftk.sh #PDF Toolkit allows for merging, splitting, etc.
#./ingredients/productivity/xournalpp.sh #Xournal++ PDF annotation application

# Media
# --------------------------------------------------------------------------
#./ingredients/media/codecs.sh #Codecs for Audio, Images, and Video
#./ingredients/media/gpodder.sh #Excellent podcast manager
#./ingredients/media/kde-gstreamer.sh #KDE Phonon with GStreamer backend + Plugins
#./ingredients/media/tauon-music-box.sh #Tauon Music Box
#./ingredients/media/vlc.sh #VLC media player

# Gaming
# --------------------------------------------------------------------------
#./ingredients/gaming/steam.sh #Steam gaming platform

# VM
# --------------------------------------------------------------------------
#./ingredients/vm/kvm-qemu-guest.sh #KVM/QEMU guest utilities (only install if running as VM)
#./ingredients/vm/kvm-qemu-host.sh #KVM/QEMU host installation and configuration

# Icons
# --------------------------------------------------------------------------
#./ingredients/icons/0_kde-papirus-icons.sh #Papirus icon theme and config for KDE
#./ingredients/icons/papirus-icons-folders.sh indigo Papirus-Dark #Supplmental colored folders for Papirus icon theme [Requires /icons/0_xxx-papirus-icons ingredient]
# Folder colors: black, bluegrey, brown, deeporange, grey, magenta, orange, paleorange, red, violet, yaru, blue, breeze, cyan, green, indigo, nordic, palebrown, pink, teal, white, yellow

# Fonts
# --------------------------------------------------------------------------
#./ingredients/fonts/0_kde-fonts.sh #Install and configure sane fonts for KDE
#./ingredients/fonts/vscode-jetbrains-mono.sh #JetBrains Mono font for Visual Studio Code [Requires /dev/1_vscode and /fonts/0_xxx-fonts ingredients]

# Hardware
# --------------------------------------------------------------------------
#./ingredients/hardware/cpu-amd-undervolt-support.sh #Support for undervolting AMD CPUs [Requires additional configuration]
#./ingredients/hardware/mouse-logitec-solaar.sh #GUI application for managing logitec unifying receivers

# Themes
# --------------------------------------------------------------------------
#./ingredients/themes/dracula-theme-vscode.sh #Dracula theme for VSCode [Requires /dev/1_vscode ingredient]

# 14. Additional Packages
# --------------------------------------------------------------------------
# paru -S --noconfirm --needed {package1} {package2} ...

}

main "$@"
