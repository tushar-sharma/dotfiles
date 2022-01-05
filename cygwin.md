## Cygwin

1. Install cygwin from [here](https://cygwin.com/install.html). 

2. Install following packages 

* bash-completion
* fzf-zsh
* fzf-zsh-completion
* curl
* tmux
* vim
* make
* perl
* tar
* tig
* unzip
* wget
* zip 
* zsh

2. Install Oh my zsh using [Manual Installation](https://github.com/ohmyzsh/ohmyzsh#manual-installation).

4. Install fonts 

```bash
$ git clone https://github.com/powerline/fonts.git --depth=1
$ cd fonts 
$ ./install.sh
```

5. Edit the Cygwin /etc/nsswitch.conf file.

Add or edit the following line: 

```bash
db_home: /%H
db_shell: /bin/zsh
```
