#!/usr/bin/env bash
set -euo pipefail

command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew tap d12frosted/emacs-plus
brew trust d12frosted/emacs-plus

brew install \
    emacs-plus@31 \
    enchant \
    fish \
    fzf \
    git \
    ripgrep \
    sox \
    starship \
    stow \
    zoxide

brew install --cask font-iosevka
