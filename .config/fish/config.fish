if status is-interactive
    starship init fish | source
    zoxide init fish | source

    export EDITOR='emacsclient -t -n -a ""'
    alias ec='emacsclient -c -n -a ""'
    alias et='emacsclient -t -a ""'
end
