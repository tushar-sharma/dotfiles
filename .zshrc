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
ZSH_THEME="robbyrussell"

POWERLEVEL9K_MODE='awesome-fontconfig'

#ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(git zsh-autosuggestions)

export TERM="xterm-256color"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="↳ "

source ~/.bash_profile

source $ZSH/oh-my-zsh.sh
