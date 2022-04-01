#!/bin/bash
#|#./ingredients/shell/fish.sh #Fish shell

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed fish

function main() {

    install
}

function install() {

    mkdir -p ~/.config/fish/conf.d
    configure_fish_aliases
    configure_fish_tty_colors
    configure_fish_reset_colors
    configure_fish

    # Change the shell to fish
    chsh -s /usr/bin/fish

    echo -e "${YELLOW}Warning: you will need logout in order for the shell change to take effect.${NC}"
}

function configure_fish_aliases() {

    cat <<EOT > "aliases.fish"	
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias l.="ls -d .* --color=auto"
alias grep="grep --color"
alias pacman_remove_orphans="paru -c"
EOT

    cp aliases.fish ~/.config/fish/conf.d/.
    rm aliases.fish
}

function configure_fish_tty_colors {

    cat <<EOT > "tty-colors.fish"
# Set colors for TTY (Linux Virtual Console) so things look good

if [ "\$TERM" = "linux" ]
    echo -en "\e]P0282a36" #color 0: background (Dracula Background)
    echo -en "\e]PFf8f8f2" #color F: foreground (Dracula Foreground)

    echo -en "\e]P1ff79c6" #color 1: red (Dracula Pink)
    echo -en "\e]P250fa7b" #color 2: green (Dracula Green)
    echo -en "\e]P3f1fa8c" #color 3: yellow (Dracula Yellow)
    echo -en "\e]P4bd93f9" #color 4: blue (Dracula Purple)
    echo -en "\e]P5ff5555" #color 5: magenta (Dracula Red)
    echo -en "\e]P68be9fd" #color 6: cyan (Dracula Cyan)

    echo -en "\e]P7f8f8f2" #color 7: white (Dracula Foreground)
    echo -en "\e]P844475a" #color 8: b-black (Dracula Current Line)

    echo -en "\e]P9ff79c6" #color 9: b-red (Dracula Pink)
    echo -en "\e]PA50fa7b" #color 10: b-green (Dracula Green)
    echo -en "\e]PBf1fa8c" #color 11: b-yellow (Dracula Yellow)
    echo -en "\e]PCbd93f9" #color 12: b-blue (Dracula Purple)
    echo -en "\e]PDff5555" #color 13: b-magenta (Dracula Red)
    echo -en "\e]PE8be9fd" #color 14: b-cyan (Dracula Cyan)
    
    clear #for background artifacting
end
EOT

    cp tty-colors.fish ~/.config/fish/conf.d/.
    rm tty-colors.fish
}

function configure_fish_reset_colors {

    cat <<EOT > "reset-colors.fish"
# Reset all explicitly defined fish shell colors to use built in terminal colors
# Use "set_color --print-colors" to visualize all colors in the terminal

set -g fish_color_autosuggestion      brblack
set -g fish_color_cancel              -r
set -g fish_color_command             brgreen
set -g fish_color_comment             brmagenta
set -g fish_color_cwd                 green
set -g fish_color_cwd_root            red
set -g fish_color_end                 brmagenta
set -g fish_color_error               brred
set -g fish_color_escape              brcyan
set -g fish_color_history_current     --bold
set -g fish_color_host                normal
set -g fish_color_match               --background=brblue
set -g fish_color_normal              normal
set -g fish_color_operator            cyan
set -g fish_color_param               brblue
set -g fish_color_quote               yellow
set -g fish_color_redirection         bryellow
set -g fish_color_search_match        'bryellow' '--background=brblack'
set -g fish_color_selection           'white' '--bold' '--background=brblack'
set -g fish_color_status              red
set -g fish_color_user                brgreen
set -g fish_color_valid_path          --underline
set -g fish_pager_color_completion    normal
set -g fish_pager_color_description   yellow
set -g fish_pager_color_prefix        'white' '--bold' '--underline'
set -g fish_pager_color_progress      'brblack' '--background=cyan'
EOT

    cp reset-colors.fish ~/.config/fish/conf.d/.
    rm reset-colors.fish
}

function configure_fish() {

    cat <<EOT > "config.fish"
# Don't shorten the working directory in the prompt
set -g fish_prompt_pwd_dir_length 0

EOT

    cp config.fish ~/.config/fish/
    rm config.fish
}

main "$@"
