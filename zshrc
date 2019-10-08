export ARCHFLAGS="-arch x86_64"
export BROWSER=none # Node use no browser
export LANG=en_US.UTF-8
export NVM_LAZY_LOAD=false
export NVM_NO_USE=false
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export REACT_EDITOR=none # Don't fire nano in npm start
export SSH_KEY_PATH="~/.ssh/rsa_id"
export ZSH=$HOME/.oh-my-zsh
export PURE_PROMPT_SYMBOL=">"

umask 022 # set
# umask -S u=rwx,g=rx,o=rx

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="gentoo"
# ZSH_THEME="mrk-agnoster"
# ZSH_THEME="mrk-aphrodite"
ZSH_THEME=""
# autoload -U promptinit; promptinit
# prompt pure

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

# zplug
# auto-install zplug
if [[ ! -d ~/.zplug ]]; then
    echo '[zshrc] installing zplug...'
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh
zplug "lukechilds/zsh-nvm"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/git-flow",   from:oh-my-zsh
zplug "plugins/rbenv",   from:oh-my-zsh
zplug "plugins/ruby",   from:oh-my-zsh
# zplug "plugins/capistrano",   from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zplug "mattberther/zsh-pyenv"

zstyle :prompt:pure:path color 046
zstyle :prompt:pure:git:branch color 220
zstyle :prompt:pure:git:arrow color 220
zstyle :prompt:pure:host color 226
zstyle :prompt:pure:prompt:success color 226
zstyle :prompt:pure:prompt:errror color red

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# aws brew tmux tmuxinator
# plugins=(git git-flow rbenv ruby capistrano zsh-completions)
source $ZSH/oh-my-zsh.sh

# User configuration
HOSTNAME=$(hostname -s)
DEFAULT_USER=mk

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="$HOME/bin/code"
else
  export EDITOR='nano'
fi

# Server-specific commands
if [[ "$HOSTNAME" = "MK-Envy" ]] ; then
  echo -e "How splendid to have you home on $HOST, $USER, sir!"
  # source ~/.bash/crayrc
elif [[ "$HOSTNAME" = "Neumann" ]]; then
  echo -e "Welcome to the Clone Wars on $HOST, $USER!"
  source ~/.bash/neumannrc
elif [[ "$HOSTNAME" = "MSOReloaded" ]]; then
  echo -e "The Matrix has you, $USER!"
  export RAILS_ENV=production
elif [[ $IP =~ ^10.0 ]]; then
  echo -e "Yikes! It seems you are at school on $HOST, $USER!"
  source ~/.bash/msorc
else
  echo -e "Ah, I see you are entering unchartered waters on $HOST, $USER!"
fi

source ~/.bash/aliases
# complete -C ~/.bash/project_completion -o default c
function c { cd ~/GITProjects/$1; }

# prompt_context(){}

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
