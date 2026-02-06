# ============================================================================
# Zsh Configuration (Oh My Zsh)
# ============================================================================

# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# Theme & Appearance
# ============================================================================

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Enable colors
autoload -U colors && colors

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# ============================================================================
# History Configuration
# ============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ============================================================================
# Completion
# ============================================================================

autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ============================================================================
# Plugins
# ============================================================================

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git you-should-use docker docker-compose node npm python zsh-autosuggestions zsh-interactive-cd zsh-navigation-tools zsh-bat zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# Environment Variables
# ============================================================================

# Default editor
export EDITOR='micro'
export VISUAL='micro'

# ============================================================================
# Aliases
# ============================================================================

# Micro editor
alias m="micro"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts (supplements Oh My Zsh git plugin)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Development
alias py='python'
alias pip='python -m pip'
alias venv='python -m venv'

# ============================================================================
# Functions
# ============================================================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================================================
# NVM (Node Version Manager)
# ============================================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ============================================================================
# Homebrew (Linux)
# ============================================================================

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# ============================================================================
# Platform Specific Configuration
# ============================================================================

# Source machine-specific config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
