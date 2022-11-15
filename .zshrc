
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="~/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"
export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"

# ALIASES
alias ll='ls -la -G'
alias lh='ls -lah -G'
alias drive='open https://drive.google.com/drive/my-drive'
alias gmail='open https://mail.google.com/mail/u/0/#inbox'
alias calendar='open https://calendar.google.com/calendar/u/0/r?pli=1'
alias miro='open https://miro.com/app/dashboard/'
alias bonusly='open https://bonus.ly/bonuses'
alias greenhouse='open https://app2.greenhouse.io/dashboard'
alias privacytools='open https://www.privacytools.io/'
alias privacytoolslist='open https://privacytoolslist.com/'
alias explain='open https://explain.tensor.ru/'
alias system='open /System/Applications/System\ Preferences.app'
alias email='open /System/Applications/Mail.app'
alias lastpass='open /Applications/LastPass.app'
alias fireplace="caffeinate -u -t 36000"
alias update='softwareupdate -ia && brew update && brew upgrade && brew doctor && pip3 install --upgrade pip && pyenv update && ~/.pyenv/plugins/pyupdate.sh && pyenv pip-update && pyenv pip-upgrade --all'
alias networkip='ipconfig getifaddr en0'
alias myip='curl ipecho.net/plain; echo'
alias speed='speedtest-cli'
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# CUSTOM FUNCTIONS

dmg-install () {
  if [[ $# -lt 1 ]]; then
    echo "Usage: dmginstall [url]"
    exit 1
  fi
  url=$*
  # Generate a random file name
  tmp_file=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.dmg
  apps_folder='/Applications'

  # Download file
  echo "Downloading $url..."
  curl -# -L -o $tmp_file $url
  echo "Mounting image..."
  volume=`hdiutil mount $tmp_file | tail -n1 | perl -nle '/(\/Volumes\/.*?$)/; print $1'`
  # Locate .app folder and move to /Applications
  pkg=`find $volume -regex ".*\.pkg" -maxdepth 1 -type f -print0`
  app=`find $volume -regex ".*\.app" -maxdepth 1 -type d -print0`
  if [[ "$pkg" == *"Install.pkg"* ]]; then
    echo "Installing $pkg into target /..."
    sudo installer -pkg $pkg -target /
  elif [[ ! -z "$app" ]] && [ "$app" != *"Uninstall.app"* ]; then
    echo "Copying `echo $app | awk -F/ '{print $NF}'` into $apps_folder..."
    cp -ir $app $apps_folder
  else
    echo "Unknown pkg or app... Cleaning up and exiting..."
    # Unmount volume, delete temporal file
    hdiutil unmount $volume -quiet
    rm $tmp_file
    exit 1
  fi
  # Unmount volume, delete temporal file
  echo "Cleaning up..."
  hdiutil unmount $volume -quiet
  rm $tmp_file
  echo "Done!"
}

aws-profile () {
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "USAGE:"
    echo "aws-profile              <- print out current value"
    echo "aws-profile PROFILE_NAME <- set PROFILE_NAME active"
    echo "aws-profile --unset      <- unset the env vars"
  elif [ -z "$1" ]; then
    if [ -z "$AWS_PROFILE$AWS_DEFAULT_PROFILE" ]; then
      echo "No profile is set"
      return 1
    else
      echo "$AWS_PROFILE$AWS_DEFAULT_PROFILE"
    fi
  elif [ "$1" = "--unset" ]; then
    AWS_PROFILE=
    AWS_DEFAULT_PROFILE=
    # removing the vars is needed because of https://github.com/aws/aws-cli/issues/5016
    export -n AWS_PROFILE AWS_DEFAULT_PROFILE
  else
    # this check needed because of https://github.com/aws/aws-cli/issues/5546
    # requires AWS CLI v2
    if ! aws configure list-profiles | grep --color=never -Fxq -- "$1"; then
      echo "$1 is not a valid profile"
      return 2
    else
      AWS_DEFAULT_PROFILE=
      export AWS_PROFILE=$1
      export -n AWS_DEFAULT_PROFILE
    fi;
  fi;
}
# completion is kinda slow, operating on the files directly would be faster but more work
# aws configure list-profiles is only available with the AWS CLI v2.
_aws-profile-completer () {
  COMPREPLY=(`aws configure list-profiles | grep --color=never ^${COMP_WORDS[COMP_CWORD]}`)
}


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  alias-finder 
  asdf 
  aws 
  brew 
  common-aliases 
  copybuffer 
  copyfile 
  copypath 
  dirhistory 
  docker 
  docker-compose 
  dotenv 
  encode64 
  extract 
  git 
  gradle
  history-substring-search 
  jira 
  jsontools 
  macos 
  poetry 
  sudo 
  vscode 
  web-search 
  z 
  zsh-autosuggestions 
  zsh-syntax-highlighting
)


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

ZSH_WEB_SEARCH_ENGINES=(
    reddit "https://www.reddit.com/search/?q="
    searx "https://searx.be/search?q="
)


#### iTerm2 ###
source ~/.iterm2_shell_integration.zsh

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


AWS_PROFILE="retail-prod-DataWarehouse"
. /usr/local/opt/asdf/asdf.sh
fpath=(/usr/local/Cellar/asdf/0.10.0/libexec/completions /Users/patrick.roach/.oh-my-zsh/plugins/macos /Users/patrick.roach/.oh-my-zsh/plugins/jsontools /Users/patrick.roach/.oh-my-zsh/plugins/dirhistory /Users/patrick.roach/.oh-my-zsh/plugins/copybuffer /Users/patrick.roach/.oh-my-zsh/plugins/copyfile /Users/patrick.roach/.oh-my-zsh/plugins/copypath /Users/patrick.roach/.oh-my-zsh/plugins/web-search /Users/patrick.roach/.oh-my-zsh/plugins/sudo /Users/patrick.roach/.oh-my-zsh/plugins/zsh-autosuggestions /Users/patrick.roach/.oh-my-zsh/plugins/git /Users/patrick.roach/.oh-my-zsh/functions /Users/patrick.roach/.oh-my-zsh/completions /Users/patrick.roach/.oh-my-zsh/cache/completions /Users/patrick.roach/.oh-my-zsh/plugins/zsh-syntax-highlighting /Users/patrick.roach/.oh-my-zsh/plugins/zsh-autosuggestions /Users/patrick.roach/.oh-my-zsh/plugins/z /Users/patrick.roach/.oh-my-zsh/plugins/web-search /Users/patrick.roach/.oh-my-zsh/plugins/vscode /Users/patrick.roach/.oh-my-zsh/plugins/sudo /Users/patrick.roach/.oh-my-zsh/plugins/macos /Users/patrick.roach/.oh-my-zsh/plugins/jsontools /Users/patrick.roach/.oh-my-zsh/plugins/jira /Users/patrick.roach/.oh-my-zsh/plugins/history-substring-search /Users/patrick.roach/.oh-my-zsh/plugins/gradle /Users/patrick.roach/.oh-my-zsh/plugins/git /Users/patrick.roach/.oh-my-zsh/plugins/extract /Users/patrick.roach/.oh-my-zsh/plugins/encode64 /Users/patrick.roach/.oh-my-zsh/plugins/dotenv /Users/patrick.roach/.oh-my-zsh/plugins/docker-compose /Users/patrick.roach/.oh-my-zsh/plugins/docker /Users/patrick.roach/.oh-my-zsh/plugins/dirhistory /Users/patrick.roach/.oh-my-zsh/plugins/copypath /Users/patrick.roach/.oh-my-zsh/plugins/copyfile /Users/patrick.roach/.oh-my-zsh/plugins/copybuffer /Users/patrick.roach/.oh-my-zsh/plugins/common-aliases /Users/patrick.roach/.oh-my-zsh/plugins/brew /Users/patrick.roach/.oh-my-zsh/plugins/aws /Users/patrick.roach/.oh-my-zsh/plugins/alias-finder /Users/patrick.roach/.oh-my-zsh/functions /Users/patrick.roach/.oh-my-zsh/completions /Users/patrick.roach/.oh-my-zsh/cache/completions /usr/local/share/zsh/site-functions /usr/local/Cellar/zsh/5.8.1/share/zsh/functions)
autoload -Uz compinit
compinit

fpath+=~/.zfunc

eval "$(direnv hook zsh)"