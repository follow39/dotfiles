#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

. /etc/os-release
case "$ID" in
    ubuntu) ./ubuntu.sh ;;
esac

# --no-folding links each file on its own, so programs keep their caches
# and state out of this repo.
stow --verbose --no-folding --target="$HOME" .
