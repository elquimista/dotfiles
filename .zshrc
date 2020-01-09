# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Customize powerlevel9k: *MAKE SURE TO PUT THESE BEFORE SETTING ZSH_THEME*
export POWERLEVEL9K_MODE="nerdfont-complete"
export POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
export POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time ram background_jobs)
export POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
export POWERLEVEL9K_HOME_SUB_ICON="\uf07c"
export POWERLEVEL9K_FOLDER_ICON="\uf115"
export POWERLEVEL9K_ETC_ICON="\uf013"
export POWERLEVEL9K_HOME_FOLDER_ABBREVIATION=""
export POWERLEVEL9K_DIR_SHOW_WRITABLE=true

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias l='LC_COLLATE=C ls -lah' # for Linux
alias c='clear'
alias be='bundle exec'
alias dc='docker-compose'
alias brew2='HOMEBREW_BOTTLE_DOMAIN=http://artifactory.local:8081/repository/homebrew brew'
alias tmuxpace='tmux new-session \; source-file ~/.tmux.workspace.conf'

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
alias rbenv2='RUBY_BUILD_MIRROR_URL=http://artifactory.local:8081/repository/ruby-build rbenv'

# export TERM='tmux-256color-italic'
export PATH="$HOME/.bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"

# LESS: Make sure matches are highlighted with bgcolor, not with italics.
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[39;49m'

# Using GnuPG+SSH across multiple TERM sessions (e.g., multiple iTerm2 windows,
# tmux panes/windows) isn't that straightforward as you might think.
# For example, you open your first terminal window, invoke some command that
# uses GnuPG+SSH such as git repo clone over SSH connection with GPG key.
# You get a prompt (usually PINentry), type your passphrase and it seems all
# good so far.
# Now you open another terminal window (or tmux pane/window), attempt another
# GnuPG+SSH activity in it and guess what happens... The passphrase prompt shows
# up in the other pane that you used previously. Naturally you switch to that
# pane, try to enter passphrase.. and you get a weird behavior.
#
# WORKAROUND SOLUTION: In order to avoid this embarrassment, make sure you run
# the following function every time you switch terminal session from one to
# another and try to use GnuPG+SSH over there.
# Note that you don't have to run this every single time right before you
# invoke GnuPG+SSH; run it just once per session switch.
function gpgssh() {
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
  pkill ssh-agent
  ps aux | grep '[g]pg-agent' | awk '{print $2}' | xargs kill -9
  gpg-agent --daemon
}

###
# Git aliases & functions
###

alias glog='git log --stat'
alias glg='git log --pretty=format:"%C(yellow)%h%Creset %C(blue)(%cd)%Creset %s %C(magenta)%an%C(cyan)%d" --graph --date=relative'
alias glh='git-loot-hard'
alias gll='git pull origin $(git_current_branch)'

function git-loot-all() {
  source_repo="$TMPDIR/git-loot-all-source-repo"
  git clone $1 $source_repo
  git-loot --from-dir $source_repo `GIT_DIR="$source_repo/.git" git log --reverse --format="%h" --no-merges`
  rm -rf $source_repo
}

function gcmsg2() {
  if [ "$date" = "" ]; then
    gcmsg "$@"
  else
    GIT_COMMITTER_DATE="$date" GIT_AUTHOR_DATE="$date" gcmsg "$@"
  fi
}

function gcamend2() {
  if [ "$date" = "" ]; then
    gc --amend "$@"
  else
    GIT_COMMITTER_DATE="$date" gc --amend --date="$date" "$@"
  fi
}

function gcamend3() {
  GIT_COMMITTER_DATE="$(git show -s --format=%ci HEAD)" gc --amend --date="$(git show -s --format=%ai HEAD)" "$@"
}

###
# fzf
###

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --hidden --type file'
export FZF_DEFAULT_OPTS='--reverse'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

###
# Others
###

function hoeren() {
  youtube-dl -o - "$@" | mpv -vo=null --force-seekable=yes -
}

function selfsigned-sslcertgen() {
  openssl req -x509 -out $1.crt -keyout $1.key -newkey rsa:2048 -nodes -sha256 \
    -days $2 -subj "/CN=$1" -extensions EXT -config <(printf "[dn]\nCN=$1\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:$1\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
}
