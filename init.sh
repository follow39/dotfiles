#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "$(uname -s)" = Darwin ]; then
    ./macos.sh
fi

if [ -f /etc/os-release ] && . /etc/os-release && [ "$ID" = ubuntu ]; then
    ./ubuntu.sh
fi

# --no-folding links each file on its own, so programs keep their caches
# and state out of this repo.
stow --verbose --no-folding --target="$HOME" .

[ -d ~/.antidote ] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
