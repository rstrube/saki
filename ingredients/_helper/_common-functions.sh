#!/bin/bash
# Common Helper Functions

# Console Colors
NC='\033[0m'

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

ERROR_VARS_MESSAGE="${RED}Error: invalid argument value passed in.${NC}"

function check_variables_value() {
    NAME=$1
    VALUE=$2
    if [[ -z "$VALUE" ]]; then
        echo -e ${ERROR_VARS_MESSAGE}
        echo "${NAME} must have a value."
        exit 1
    fi
}

function check_variables_boolean() {
    NAME=$1
    VALUE=$2
    case $VALUE in
        true )
            ;;
        false )
            ;;
        * )
            echo -e ${ERROR_VARS_MESSAGE}
            echo "${NAME} must be {true|false}."
            exit 1
            ;;
    esac
}

function check_flatpak_prereq() {

    if [[ ! -e /usr/bin/flatpak ]]; then
        echo -e "${RED}Error: flatpak must be installed.${NC}"
        exit 1
    fi
}

function print_help_if_neccessary() {

    if [[ "$1" == "--help" ]]; then
        print_help
        exit 0
    fi
}
