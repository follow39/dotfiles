#!/bin/sh
# Claude Code status line: repository, branch, worktree marker and diff size.

blue() { printf '\033[34m%s\033[0m' "$1"; }
green() { printf '\033[32m%s\033[0m' "$1"; }
red() { printf '\033[31m%s\033[0m' "$1"; }

cd "$(jq -r .workspace.current_dir)" 2>/dev/null || exit 0
common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0

blue "$(basename "${common%/.git}")"
printf '  %s' "$(git branch --show-current)"
[ "$common" = "$(git rev-parse --path-format=absolute --git-dir)" ] || printf ' (worktree)'

set -- $(git diff HEAD --numstat 2>/dev/null | awk '{a += $1; d += $2} END {print a + 0, d + 0}')
[ "$1$2" = 00 ] || { printf ' '; green "+$1"; printf /; red "-$2"; }
