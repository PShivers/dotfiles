# ============================================================================
# Zsh Configuration
# ============================================================================

# Path to your oh-my-zsh installation (configured automatically below)

# ============================================================================
# Theme & Appearance
# ============================================================================

ZSH_THEME="agnoster"

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

# Git shortcuts (most provided by oh-my-zsh git plugin)

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Development
alias py='python'
alias pip='python -m pip'
alias venv='python -m venv'

# Editor
alias edit='micro'
alias m='micro'

# ============================================================================
# Environment Variables
# ============================================================================

# Default editor
export EDITOR='micro'
export VISUAL='micro'

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
# Oh My Zsh
# ============================================================================

if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    plugins=(git docker kubectl node npm python zsh-autosuggestions zsh-syntax-highlighting you-should-use)
    source $ZSH/oh-my-zsh.sh

    # Show username only (no hostname) in prompt
    prompt_context() {
        prompt_segment "$AGNOSTER_CONTEXT_BG" "$AGNOSTER_CONTEXT_FG" "%n"
    }
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
