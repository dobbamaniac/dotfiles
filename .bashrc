# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\n \[\e[0;36m\]\u@\h \[\e[1;4;31m\]\w\[\e[0m\] $ '

PATH="$HOME/.bin:${PATH:+:${PATH}}"

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind "set completion-ignore-case on"
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

shopt -s autocd
shopt -s histappend

#export CM_LAUNCHER=rofi
export HISTFILE=~/.bash_hist
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTFILESIZE=10000
export HISTSIZE=5000
export PROMPT_COMMAND='history -a'
export TERM=xterm-kitty
export EDITOR=gedit
export VISUAL="vim"

alias ls='exa -a --color=always --group-directories-first --git --icons'
alias grep='grep --color=auto'
alias ..='cd ..'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function cd() {
    if builtin cd "$@"; then
        exa --header --color=always --group-directories-first --git --icons
    fi
}

(cat ~/.config/wpg/sequences &)
