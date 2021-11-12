#!/bin/bash
#|#./ingredients/shell/fish.sh #Fish shell

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed fish

function main() {

    install
}

function install() {

    configure_fish_aliases
    configure_fish_colors
    configure_fish
}

function configure_fish_aliases() {

    cat <<EOT > "aliases.fish"	
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias l.="ls -d .* --color=auto"
alias grep="grep --color"
alias pacman_remove_orphans="paru -c"
EOT

    mkdir -p ~/.config/fish
    cp aliases.fish ~/.config/fish/
    rm aliases.fish
}

function configure_fish_colors {

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

    cp reset-colors.fish ~/.config/fish/
    rm reset-colors.fish
}

function configure_fish() {

    cat <<EOT > "config.fish"
# Don't shorten the working directory in the prompt
set -g fish_prompt_pwd_dir_length 0

# Aliases
source ~/.config/fish/aliases.fish

# Reset Colors
source ~/.config/fish/reset-colors.fish
EOT

    cp config.fish ~/.config/fish/
    rm config.fish
}

main "$@"

# Change the shell to fish
chsh -s /usr/bin/fish

echo -e "${YELLOW}Warning: you will need logout in order for the shell change to take effect.${NC}"
