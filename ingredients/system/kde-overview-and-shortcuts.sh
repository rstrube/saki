#!/bin/bash
#|#./ingredients/system/kde-overview-and-shortcuts.sh #Enable new Plasma overview feature and set sane shortcuts

# Enable Overview plugin
kwriteconfig5 --file kwinrc --group Plugins --key overviewEnabled "true"

# Set Overview keyboard shortcut to "Meta" (like Gnome)
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.kglobalaccel,/component/kwin,,invokeShortcut,Overview"

# Set KRunner keyboard shortcut to "Meta+Space"
kwriteconfig5 --file kglobalshortcutsrc --group org.kde.krunner.desktop --key _launch "Alt+F2\tSearch\tMeta+Space\tAlt+Space,Alt+Space\tAlt+F2\tSearch,KRunner"

# Reconfigure KWin to reflect changes immediately
qdbus org.kde.KWin /KWin reconfigure