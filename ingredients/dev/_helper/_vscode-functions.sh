#!/bin/bash
# VSCode Helper Functions

VSCODE_SETTINGS_DIR_PATH="${HOME}/.config/Code/User"
VSCODE_SETTINGS_FILE_PATH="${VSCODE_SETTINGS_DIR_PATH}/settings.json"

function create_empty_vscode_settings_if_neccessary {

    if [[ ! -d "$VSCODE_SETTINGS_DIR_PATH" ]]; then
        mkdir -p "$VSCODE_SETTINGS_DIR_PATH"
    fi

    if [[ ! -e "$VSCODE_SETTINGS_FILE_PATH" ]]; then
        echo "Creating an empty VSCode settings.json file..."

        echo "{" > "$VSCODE_SETTINGS_FILE_PATH"
        echo "}" >> "$VSCODE_SETTINGS_FILE_PATH"
    fi
}
