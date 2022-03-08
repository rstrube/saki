#!/bin/bash
# Font Installation, Fontconfig

function install_fonts {
    # Install the following fonts:
    # Font Awesome: Provides common font icons
    # Roboto: default font for Google's Android OS
    # Fira Code: https://github.com/tonsky/FiraCode
    # Jetbrains Mono: a fantastic monospace font
    # Droid: another common font that came with Google's Android OS
    # Liberation: font family which aims at metric compatibility with Arial, Times New Roman, and Courier New
    paru -S --noconfirm --needed otf-font-awesome ttf-roboto ttf-roboto-mono ttf-fira-code ttf-jetbrains-mono ttf-droid ttf-liberation

    # This rebuilds the font-cache, taking into account any changes
    sudo fc-cache -r -v
}

function setup_local_fontconfig {
    # Setup a local fonts.conf to ensure that fallbacks for JetBrains Mono and Fira Code use other monospoce fonts first
    # See: https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/
    if [[ ! -d "~/.config/fontconfig" ]]; then
        mkdir -p ~/.config/fontconfig
    fi

    cat <<EOT > "fonts.conf"
<fontconfig>
    <!-- register JetBrains Mono and Fira Code as monospace fonts -->
    <alias>
        <family>JetBrains Mono</family>
        <default>
            <family>monospace</family>
        </default>
    </alias>
    <alias>
        <family>Fira Code</family>
        <default>
            <family>monospace</family>
        </default>
    </alias>

    <!-- by default fontconfig assumes any unrecognized font is sans-serif, so -->
    <!-- the fonts above now have /both/ families.  fix this. -->
    <!-- note that "delete" applies to the first match deleting the sans-serif family only -->
    <match>
        <test compare="eq" name="family">
            <string>sans-serif</string>
        </test>
        <test compare="eq" name="family">
            <string>monospace</string>
        </test>
        <edit mode="delete" name="family"/>
    </match>
</fontconfig>
EOT

    mv fonts.conf ~/.config/fontconfig/
}

function test_coverage {
    # Test font coverage for specific unicode characters required by PowerLine
    echo "Testing font coverage..."
    echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699 \u2800 \u28ff \u25a0 \u25ff \u2500 \u259f"
}
