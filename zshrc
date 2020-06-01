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

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:ow=37;42:'

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
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
# zplug mafredri/zsh-async, from:github
# zplug "plugins/capistrano",   from:oh-my-zsh
# zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zplug "mattberther/zsh-pyenv"
zplug romkatv/powerlevel10k, as:theme, depth:1

# zstyle :prompt:pure:path color 046
# zstyle :prompt:pure:git:branch color 220
# zstyle :prompt:pure:git:arrow color 220
# zstyle :prompt:pure:host color 226
# zstyle :prompt:pure:prompt:success color 226
# zstyle :prompt:pure:prompt:errror color red

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

cd ~/GITProjects
