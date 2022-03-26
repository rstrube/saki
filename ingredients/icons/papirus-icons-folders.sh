#!/bin/bash
#|#./ingredients/icons/papirus-icons-folders.sh indigo Papirus-Dark #Supplmental colored folders for Papirus icon theme [Requires /icons/0_xxx-papirus-icons ingredient]
#|# Folder colors: black, bluegrey, brown, deeporange, grey, magenta, orange, paleorange, red, violet, yaru, blue, breeze, cyan, green, indigo, nordic, palebrown, pink, teal, white, yellow

# Please see https://github.com/PapirusDevelopmentTeam/papirus-folders for a galley of all the folder colors that are available

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

FOLDER_COLOR=""

function main() {
    
    check_args "$@"

    if [[ "$#" -eq 2 ]]; then
        FOLDER_COLOR="$1"
        THEME_NAME="$2"
    fi

    check_variables

    if [[ "$THEME_NAME" != "Papirus" && "$THEME_NAME" != "Papirus-Dark" ]]; then
        echo -e "${RED}Theme name must == Papirus || Papirus-Dark ${NC}"
    fi

    install
}

function install() {

    echo "Setting papirus icons folder color to '$FOLDER_COLOR' via 'papirus-folders'..."

    paru -S --noconfirm --needed papirus-folders
    papirus-folders -C $FOLDER_COLOR --theme $THEME_NAME
}

function check_args() {
    
    print_help_if_neccessary "$@"

    if [[ "$#" -ne 2 ]]; then
        echo -e "${RED}Error: this script must be run with two arguments.${NC}"
        echo ""
        print_help
        exit 1
    fi
}

function print_help() {

    echo -e "${LBLUE}Usage: "$0" {Folder Color} {Theme Name}${NC}"
}

function check_variables() {

    check_variables_value "FOLDER_COLOR" "$FOLDER_COLOR"
    check_variables_value "THEME_NAME" "$THEME_NAME"
}

main "$@"
