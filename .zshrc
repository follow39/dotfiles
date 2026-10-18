HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_all_dups auto_cd

source ~/.antidote/antidote.zsh
antidote load

# Run after `antidote load', which adds the plugin completions to `fpath'.
autoload -Uz compinit && compinit

HISTORY_SUBSTRING_SEARCH_FUZZY=1
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

export FZF_CTRL_R_OPTS='--exact'
source <(fzf --zsh)

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export EDITOR='emacsclient -t -a ""'
alias ec='emacsclient -c -n -a ""'
alias et='emacsclient -t -a ""'

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
