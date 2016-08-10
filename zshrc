# Path to your oh-my-zsh installation.
export ZSH=/Users/($whoami)/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
# ZSH_THEME="lambda-mod"
# ZSH_THEME="geometry"
ZSH_THEME="pure3"
DEFAULT_USER=`whoami`

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/Users/($whoami)/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/redis-3.0.7/src"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="/Users/($whoami)/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

alias glg2='git log --pretty=format:"%Cblue%h%Creset - %Cgreen(%cd)%Creset %s - %an%C(yellow)%d" --graph --date=relative'

# older aliases, not as relevant for docker, but included all the same
alias be='bundle exec'
alias arc='bundle exec rails c development'
alias arcs='bundle exec rails c staging'
alias arcp='bundle exec rails c production'
alias arcpl='bundle exec rails c production_local'

# for starting up
# alias dm='docker-machine'
# alias dmstart='dm start default'
# in macOS use this
alias dmstart='dlite start'
alias dc='docker-compose'

# dc up    # docker-compose up
# dc stop  # docker-compose stop # development enviornment
# dc build # to build a dockers setup

# dexec opens a shell on a running image based on its name
function dexec {
  docker exec -it $1 /bin/bash
}

# open a bash prompt on a server on startup
function dbash {
  docker run --rm -i -t -e TERM=xterm --entrypoint /bin/bash $1
}

alias dstopall="docker stop $(docker ps -a -q)"

# this literally blows away your entire system to start over. Be careful
# as this will delete every image and container there is.. but, you can
# rebuild you just have to reimport the data
function dnuke {
  echo
  echo "Stop all containers"
  docker stop $(docker ps -a -q)

  echo
  echo "Delete all containers"
  docker rm $(docker ps -a -q)

  echo
  echo "Delete all images"
  docker rmi $(docker images -q)

  # echo
  # echo "Delete all volumes"
  # rm -rf /var/lib/docker/volumes/*
  # rm -rf /var/lib/docker/vfs/dir/*

  echo
  echo "Old style to pick up danglers"
  docker ps -a | sed '1 d' | awk '{print $1}' | xargs -L1 docker rm
  docker images -a | sed '1 d' | awk '{print $3}' | xargs -L1 docker rmi -f
  docker volume rm $(docker volume ls -qf dangling=true)

  echo
  echo
  echo "Finished nuking"
}

# sees if one system and ping another
function dping {
  docker exec $1 /bin/ping $2
}

function dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

