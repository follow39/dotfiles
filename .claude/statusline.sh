#!/bin/sh
# Claude Code status line:
#   1. the session name
#   2. the repository, branch, worktree marker, uncommitted diff size and
#      lines changed by Claude
#   3. the session (5-hour) and weekly limit use with their reset times

blue() { printf '\033[34m%s\033[0m' "$1"; }
green() { printf '\033[32m%s\033[0m' "$1"; }
red() { printf '\033[31m%s\033[0m' "$1"; }

# Print "+$1/-$2" in color, unless both are zero.
diff_size() {
    [ "$1$2" = 00 ] || { green "+$1"; printf /; red "-$2"; }
}

# A non-whitespace separator, so that `read' keeps empty fields.
# LC_ALL=C gives English day names.
IFS=$(printf '\037') read -r dir added removed limit reset week week_reset name <<EOF
$(LC_ALL=C jq -r '[.workspace.current_dir,
          .cost.total_lines_added // 0,
          .cost.total_lines_removed // 0,
          (.rate_limits.five_hour.used_percentage // "" | if . == "" then . else floor end),
          (.rate_limits.five_hour.resets_at // "" | if . == "" then . else strflocaltime("%H:%M") end),
          (.rate_limits.seven_day.used_percentage // "" | if . == "" then . else floor end),
          (.rate_limits.seven_day.resets_at // "" | if . == "" then . else strflocaltime("%a %H:%M") end),
          .session_name // ""]
         | map(tostring) | join("\u001f")')
EOF

[ -z "$name" ] || printf '%s\n' "$name"

if cd "$dir" 2>/dev/null &&
    common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
    blue "$(basename "${common%/.git}")"
    printf '  %s' "$(git branch --show-current)"
    [ "$common" = "$(git rev-parse --path-format=absolute --git-dir)" ] || printf ' (worktree)'

    set -- $(git diff HEAD --numstat 2>/dev/null | awk '{a += $1; d += $2} END {print a + 0, d + 0}')
    [ "$1$2" = 00 ] || { printf ' '; diff_size "$1" "$2"; }
    [ "$added$removed" = 00 ] || { printf ' ('; diff_size "$added" "$removed"; printf ')'; }
    printf '\n'
fi

[ -z "$limit" ] || printf 'session %s%%, resets %s' "$limit" "$reset"
[ -z "$limit" ] || [ -z "$week" ] || printf ' · '
[ -z "$week" ] || printf 'week %s%%, resets %s' "$week" "$week_reset"
[ -z "$limit$week" ] || printf '\n'
