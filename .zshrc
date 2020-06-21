# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
# PS1="%F{14}%M %F{33}%~%{$reset_color%}% %b "
# PS1="%F{33}@%F{231}%M %F{231}%~%{$reset_color%}% %b "
PS1="%B%F{86}[%F{15}%~%F{86}]%{$reset_color%} $%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
alias pac="sudo pacman"
alias ls="ls -CFhN --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias rm="rm -v"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkd='mkdir -pv'
alias vim='nvim'
alias SS='sudo systemctl'
alias conf='cd ~vlad/.config'
alias cfi='nvim ~vlad/.config/i3/config'
alias cfx='nvim ~vlad/.config/Xdefaults'
alias cfv='nvim ~vlad/.config/nvim/init.vim'
alias cfz='nvim ~vlad/.zshrc'
alias wthr='curl wttr.in'
alias corona='curl https://corona-stats.online'
alias mem='pydf -h'
alias clock='termtime'
alias ytmp3='youtube-dl -x -f -i bestaudio/best'
alias ef='fzf | xargs -r -I % $EDITOR %'
alias ec="cd ~/.config; find -type f | fzf | xargs -r -I % $EDITOR %"
alias art="python3 ~/docs/ascii_art/ascii.py"
alias hello="cat ~/docs/ascii_art/hello | lolcat"
alias testosterone="cat ~/docs/ascii_art/chlen | lolcat"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[1 q"
}
zle -N zle-line-init
echo -ne '\e[1 q' # Use block shape cursor on startup.
preexec() { echo -ne '\e[1 q' ;} # Use block shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
