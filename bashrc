# if we're not an interactive shell, do nothing
# necessary to ensure sftp works
[ -z "$PS1" ] && return

echo "bashrc"

export CLICOLOR=1
export EDITOR="/usr/local/bin/code"
# export LSCOLORS=GxFxCxDxBxegedabagaced
export MANPATH=/usr/share/man:/usr/local/share/man:/usr/local/man
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Make CFString use UTF8 as default encoding
# (Handy for pbcopy/pbpaste which uses defaultCStringEncoding)
# export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100 # obsolete?
export LANG=en_US.UTF-8

# bind '"[A":history-search-backward'
# bind '"[B":history-search-forward'

# Get OS name
OS=$( uname -s )

# ===========
# = History =
# ===========
# Do *not* append the following to our history: consecutive duplicate
# commands, ls, bg and fg, and exit
# Don't keep useless history commands. Note the last pattern is to not
# keep dangerous commands in the history file.  Who really needs to
# repeat the shutdown(8) command accidentally from your command
# history?
HISTIGNORE='\&:fg:bg:l:ls:pwd:cd ..:cd ~-:cd -:cd:jobs:set -x:ls -l:ls -l:ll:..:...:tra:ror:mso:mrk:rst:apa:c *'
HISTIGNORE=${HISTIGNORE}':%1:%2:popd:top:pine:mutt:shutdown*:reboot:clear*'
export HISTIGNORE

# Save multi-line commands in history as single line
shopt -s cmdhist

# Disk is cheap. Memory is cheap. My memory isn't! Keep a lot of
# history by default. 10K lines seems to go back about 6 months, and
# captures all of the wacky one-off shell scripts that I might want
# again later.
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}

# Reduce redundancy in the history file
export HISTCONTROL=ignoredups

# Do not delete your precious history file before writing the new one
shopt -s histappend

# This is useful for embedded newlines in commands and quoted arguments
shopt -s lithist

# ==============
# = Completion =
# ==============
source ~/.bash/git_completion
complete -C ~/.bash/project_completion -o default c
function c { cd ~/GITProjects/$1; }
complete -C ~/.bash/rake_completion -o default rake
complete -C ~/.bash/capistrano_completion -o default cap

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [[ `which brew` > /dev/null && -f `brew --prefix`/etc/bash_completion ]]; then
  . `brew --prefix`/etc/bash_completion
fi

# ==================
# = Prompt-Related =
# ==================
# Define some colors first:
# source ~/.bash/coloursrc
# PROMPT_COMMAND='export ERR=$?'
# export PROMPT_COMMAND='echo -n "]1;$PWD"'
# GIT_PS1_SHOWDIRTYSTATE='YES'
# GIT_PS1_SHOWUNTRACKEDFILES='YES'
# if [[ -n "$DISPLAY" ]] ; then					# Our display is on this computer
#   PS1="\[${BRIGHT_GREEN}\]\h"
# else											# We are elsewhere in the network
#   PS1="\[${GREEN}\]\h"
# fi
# # PS1="${PS1} \[${BRIGHT_YELLOW}\]\u \[${BRIGHT_BLUE}\]\W"
# if [[ $HOME =~ ^/Users/* ]]; then				# On a local machine, enable git status
# 	PS1="${PS1}\[${RED}\]"'$(__git_ps1 " (%s)")'
# fi
# PS1="${PS1} \[${YELLOW}\]\\$ \[${RESET}\]"

export LC_CTYPE=en_US.UTF-8

source ~/.bash/aliases
# source ~/.bash/functions
if [[ "$OS" = "Darwin" ]] ; then
  # Apple Mac
  source ~/.bash/darwinrc
else
  source ~/.bash/linuxrc
fi

if which direnv > /dev/null; then eval "$(direnv hook $0)"; fi

# ==========================
# = Host-specific commands =
# ==========================
# HOSTNAME=$(ruby -e "puts '`hostname -s`'.capitalize")
HOSTNAME=$(hostname -s)
HOSTNAME=$(echo -n "${HOSTNAME:0:1}" | tr "[:lower:]" "[:upper:]"; echo -n "${HOSTNAME:1}")
# HOSTSTR="${BRIGHT_RED}$HOSTNAME${NC}"
IP=`ruby -e 'require "socket"; print Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address'`

if [[ "$USER" == "mk" ]]; then
  USERSTR="${BRIGHT_YELLOW}Mister K.${NC}"
elif [[ "$USER" == "mksadmin" ]]; then
  USERSTR="oh ${BRIGHT_YELLOW}Master of All Things${NC}"
elif [[ "$USER" == "mkadmin" ]]; then
  USERSTR="${BRIGHT_YELLOW}Master of Small Things${NC}"
else
  USERSTR="${BRIGHT_YELLOW}$USER${NC}"
fi

HOSTSTR=$HOSTNAME
USERSTR="mk"

# if [[ "$HOSTNAME" = "Cray" ]] ; then
#   echo -e "How splendid to have you back home on $HOSTSTR, $USERSTR, sir!"
#   source ~/.bash/crayrc
# elif [[ "$HOSTNAME" = "Neumann" ]]; then
#   echo -e "Welcome to the Clone Wars on $HOSTSTR, $USERSTR!"
#   source ~/.bash/neumannrc
# elif [[ "$HOSTNAME" = "MSOReloaded" ]]; then
#   echo -e "The Matrix has you, $USERSTR!"
# elif [[ "$HOSTNAME" = "MisterK" ]]; then
#   echo -e "Welcome to you virtual home, $USERSTR!"
# elif [[ $IP =~ ^10.0 ]]; then
#   echo -e "Yikes! It seems you are at school on $HOSTSTR, $USERSTR!"
#   source ~/.bash/msorc
# else
#   echo -e "Ah, I see you are entering unchartered waters on $HOSTSTR, $USERSTR!"
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
