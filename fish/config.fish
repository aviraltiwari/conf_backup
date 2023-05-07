alias ls='exa -a --icons'
alias fd='fdfind'
alias e='fzf-tmux -p | xargs nvim'
alias fconf='nvim ~/.config/fish/config.fish'
alias nconf='nvim ~/.config/nvim/init.lua'
if status is-interactive
    # Commands to run in interactive sessions can go here
    and not set -q TMUX
    exec tmux
end
