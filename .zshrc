GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="$HOME/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

eval "$(sheldon source)"

export EDITOR='emacs -Q -nw'
export VISUAL='emacs -Q -nw'

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

###  RPP-BEGIN  ###
# Do not change content between BEGIN and END!
# This section is managed by a script.
if [[ -d "/usr/libexec/rpp_zshrc.d" ]]; then
    for rc_script in "/usr/libexec/rpp_zshrc.d/"*; do
      source "${rc_script}"
    done
fi
###  RPP-END  ###
