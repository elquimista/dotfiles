# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/($whoami)/.oh-my-zsh

# Customize powerlevel9k: *MAKE SURE TO PUT THESE BEFORE SETTING ZSH_THEME*
export POWERLEVEL9K_MODE="nerdfont-complete"
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time ram background_jobs)
export POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
export POWERLEVEL9K_HOME_SUB_ICON="\uf07c"
export POWERLEVEL9K_FOLDER_ICON="\uf115"
export POWERLEVEL9K_ETC_ICON="\uf013"
export POWERLEVEL9K_HOME_FOLDER_ABBREVIATION=""
export POWERLEVEL9K_DIR_SHOW_WRITABLE=true

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster"  )

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
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION  ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias glg2='git log --pretty=format:"%Cblue%h%Creset - %Cgreen(%cd)%Creset %s - %an%C(yellow)%d" --graph --date=relative'
alias be='bundle exec'
alias dc='docker-compose'

alias c='clear'
alias l='LC_COLLATE=C ls -lah'

export PATH="$HOME/.bin:$HOME/.cargo/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"

function git-loot-all() {
  source_repo="$TMPDIR/git-loot-all-source-repo"
  git clone $1 $source_repo
  git-loot --from-dir $source_repo `GIT_DIR="$source_repo/.git" git log --reverse --format="%h" --no-merges`
  rm -rf $source_repo
}

function gducommandcopy() {
  date=$(git show -s --format="%ci" $1 | tr -d '\n')
  echo "GIT_COMMITTER_DATE='$date' gc --amend --no-edit --date='$date'" | pbcopy
}

function gmsgcopy() {
  git show -s --format="%B" $1 | pbcopy
}

alias glh='git-loot-hard'
alias gll='git pull origin $(git_current_branch)'

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

function selfsigned-sslcertgen() {
  openssl req -x509 -out $1.crt -keyout $1.key -newkey rsa:2048 -nodes -sha256 \
    -days $2 -subj "/CN=$1" -extensions EXT -config <(printf "[dn]\nCN=$1\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:$1\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
}
