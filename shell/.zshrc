# ============================================================================
# Zsh Configuration
# ============================================================================

# Path to your oh-my-zsh installation (if using)
# export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# Theme & Appearance
# ============================================================================

# ZSH_THEME="robbyrussell"  # Uncomment if using oh-my-zsh

# Enable colors
autoload -U colors && colors

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
# Aliases
# ============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts
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
# Environment Variables
# ============================================================================

# Default editor
export EDITOR='vim'
export VISUAL='vim'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

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
# Platform Specific Configuration
# ============================================================================

# Source platform-specific config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# Oh My Zsh (Uncomment if using)
# ============================================================================

# plugins=(git docker kubectl node npm python)
# source $ZSH/oh-my-zsh.sh
