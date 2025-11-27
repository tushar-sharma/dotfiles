# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
# Installation
## $ sudo apt-get install zsh
## $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
## $ git clone https://github.com/powerline/fonts.git
## $ cd fonts
## $ ./install.sh
## $ git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git 
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


export TERM="xterm-256color"

ZSH_THEME="powerlevel10k/powerlevel10k"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Ensure exa is available
if (( ! ${+commands[exa]} )); then
  return 1
fi



export EXA_COLORS='da=1;34:gm=1;34'
alias sl='ls'
alias ls='exa --group-directories-first'
alias ll='ls -l'        # Long format, git status
alias l='ll -a'               # Long format, all files
alias lr='ll -T'              # Long format, recursive as a tree
alias lx='ll -sextension'     # Long format, sort by extension
alias lk='ll -ssize'          # Long format, largest file size last
alias lt='ll -smodified'      # Long format, newest modification time last
alias lc='ll -schanged'       # Long format, newest status change (ctime) last

# set alias 
alias g='git'
alias tg='tig grep'


# make git commit easy
ci() { git commit -m "$1"; }

cp() {
  g au;
  git commit -m "$1";
  g p;
}

autoload -U compinit && compinit

# install delta https://github.com/dandavison/delta
dfcmd() {
  if [ "$1" = "-c" ] || [ "$1" = "--cached" ]; then
     shift
     git --no-pager diff --cached -- "$@" | delta --side-by-side --line-numbers
  else
     git --no-pager diff -- "$@" | delta --side-by-side --line-numbers
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
