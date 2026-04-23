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



# set alias 
alias g='git'
alias tg='tig grep'

# ============================================================================
# Eza Configuration
# ============================================================================
# Enhanced color scheme for eza
export EXA_COLORS='da=1;34:gm=1;34:ga=1;32:gd=1;31:ur=1;33:uw=1;31:ux=1;32:ue=1;32'
# da=directories (bold blue)
# gm=git modified (bold blue)
# ga=git added (bold green)
# gd=git deleted (bold red)
# ur/uw/ux/ue=user permissions (yellow/red/green)

# List with colors and details
if command -v eza &> /dev/null; then
    # Base aliases with git integration and icons
    alias ls='eza --group-directories-first --git --icons'
    alias ll='eza -lh --group-directories-first --git --icons'
    alias la='eza -lah --group-directories-first --git --icons'
    alias l='eza -lh --sort=modified --reverse --git --icons'

    # Additional useful aliases
    alias lr='ll -T'                      # Long format, recursive as a tree
    alias lx='ll -s extension'            # Long format, sort by extension
    alias lk='ll -s size'                 # Long format, largest file size last
    alias lt='ll -s modified'             # Long format, newest modification time last
    alias lc='ll -s changed'              # Long format, newest status change (ctime) last
    alias ld='eza -lah --git --header --group --icons'  # Detailed view with headers
else
    alias ll='ls -lh'
    alias la='ls -lah'
    alias l='ls -ltr'
fi


# make git commit easy
ci() { git commit -m "$1"; }

cp() {
  g au;
  git commit -m "$1";
  g p;
}

autoload -U compinit && compinit

# install delta https://dandavison.github.io/delta/installation.html
dfcmd() {
  if [ "$1" = "-c" ] || [ "$1" = "--cached" ]; then
     shift
     git --no-pager diff --cached -- "$@" | delta --side-by-side --line-numbers
  else
     git --no-pager diff -- "$@" | delta --side-by-side --line-numbers
  fi
}

