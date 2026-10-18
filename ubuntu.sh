#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install --yes \
    emacs \
    fish \
    fonts-iosevka \
    fzf \
    git \
    libenchant-2-dev \
    libsox-fmt-pulse \
    ripgrep \
    sox \
    starship \
    stow \
    zoxide \
    zsh

sudo chsh -s /usr/bin/zsh "$USER"
