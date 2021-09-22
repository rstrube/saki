#!/bin/bash
#|#./ingredients/dev/git-credential-manager-core.sh #Git Crendential Manager (.NET Core based)

paru -S --noconfirm --needed git-credential-manager-core-bin

# Configure credential-manager-core
git credential-manager-core configure

# Configure git to use freedesktop.org Secret Service API, see https://github.com/microsoft/Git-Credential-Manager-Core/blob/main/docs/linuxcredstores.md for more options
git config --global credential.credentialStore secretservice
