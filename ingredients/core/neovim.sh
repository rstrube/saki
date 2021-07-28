#!/bin/bash
#|#./ingredients/core/neovim.sh #Neovim (replaces vim)

paru -Rns --noconfirm vim
paru -S --noconfirm --needed neovim
sudo ln -s /usr/bin/nvim /usr/bin/vim
