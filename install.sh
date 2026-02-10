#!/bin/bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}==> $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$file" "$backup"
        print_warning "Backed up existing file to $backup"
    fi
}

create_symlink() {
    local source=$1
    local target=$2

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file
    backup_file "$target"

    # Create symlink
    ln -s "$source" "$target"
    print_success "Linked $target -> $source"
}

# ============================================================================
# Dependency Installation (Linux)
# ============================================================================

install_dependencies() {
    print_header "Checking Dependencies"

    # Check for apt (Debian/Ubuntu)
    if ! command -v apt &> /dev/null; then
        print_warning "apt not found — dependency installation is only supported on Debian/Ubuntu"
        return
    fi

    # curl
    if ! command -v curl &> /dev/null; then
        read -p "curl is not installed. Install it? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt install -y curl
            print_success "curl installed"
        fi
    else
        print_success "curl is already installed"
    fi

    # git
    if ! command -v git &> /dev/null; then
        read -p "git is not installed. Install it? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt install -y git
            print_success "git installed"
        fi
    else
        print_success "git is already installed"
    fi

    # zsh
    if ! command -v zsh &> /dev/null; then
        read -p "zsh is not installed. Install it? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt install -y zsh
            print_success "zsh installed"
        fi
    else
        print_success "zsh is already installed"
    fi

    # micro text editor
    if ! command -v micro &> /dev/null; then
        read -p "micro text editor is not installed. Install it? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt install -y micro
            print_success "micro installed"
        fi
    else
        print_success "micro is already installed"
    fi

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        read -p "Oh My Zsh is not installed. Install it? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v curl &> /dev/null; then
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
                print_success "Oh My Zsh installed"
            else
                print_error "curl is required to install Oh My Zsh"
            fi
        fi
    else
        print_success "Oh My Zsh is already installed"
    fi

    # Oh My Zsh custom plugins
    if [ -d "$HOME/.oh-my-zsh" ]; then
        ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
            print_success "zsh-autosuggestions plugin installed"
        else
            print_success "zsh-autosuggestions plugin already installed"
        fi

        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
            print_success "zsh-syntax-highlighting plugin installed"
        else
            print_success "zsh-syntax-highlighting plugin already installed"
        fi

        if [ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]; then
            git clone https://github.com/MichaelAqworter-Ly/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use"
            print_success "you-should-use plugin installed"
        else
            print_success "you-should-use plugin already installed"
        fi
    fi

    # Set zsh as default shell
    if command -v zsh &> /dev/null; then
        current_shell=$(basename "$SHELL")
        if [ "$current_shell" != "zsh" ]; then
            read -p "Set zsh as your default shell? [y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                chsh -s "$(which zsh)"
                print_success "Default shell set to zsh"
            fi
        else
            print_success "zsh is already the default shell"
        fi
    fi
}

# ============================================================================
# Installation Functions
# ============================================================================

install_shell_config() {
    print_header "Installing Shell Configuration"

    if [ -f "$DOTFILES_DIR/shell/.zshrc" ]; then
        create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
    fi

    if [ -f "$DOTFILES_DIR/shell/.bashrc" ]; then
        create_symlink "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
    fi
}

install_git_config() {
    print_header "Installing Git Configuration"

    if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
        create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    fi

    if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
        create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    fi

    print_warning "Don't forget to update your Git user.name and user.email in ~/.gitconfig"
}

install_vscode_config() {
    print_header "Installing VSCode Configuration"

    # Determine VSCode config directory
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        VSCODE_DIR="$APPDATA/Code/User"
    else
        VSCODE_DIR="$HOME/.config/Code/User"
    fi

    if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
        create_symlink "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"
    fi

    if [ -f "$DOTFILES_DIR/vscode/keybindings.json" ]; then
        create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
    fi

    # Install extensions
    if [ -f "$DOTFILES_DIR/vscode/extensions.txt" ] && command -v code &> /dev/null; then
        print_header "Installing VSCode Extensions"
        grep -v '^#' "$DOTFILES_DIR/vscode/extensions.txt" | grep -v '^$' | while read -r extension; do
            code --install-extension "$extension" --force
        done
        print_success "VSCode extensions installed"
    fi

    # Install custom themes
    if [ -d "$DOTFILES_DIR/vscode/themes" ]; then
        print_header "Installing Custom VSCode Themes"

        # Determine VSCode extensions directory
        if [[ "$OSTYPE" == "darwin"* ]]; then
            VSCODE_EXT_DIR="$HOME/.vscode/extensions"
        elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
            VSCODE_EXT_DIR="$HOME/.vscode/extensions"
        else
            VSCODE_EXT_DIR="$HOME/.vscode/extensions"
        fi

        # Copy theme directories
        for theme_dir in "$DOTFILES_DIR/vscode/themes"/*; do
            if [ -d "$theme_dir" ]; then
                theme_name=$(basename "$theme_dir")
                target_dir="$VSCODE_EXT_DIR/$theme_name"

                # Remove existing theme if present
                if [ -d "$target_dir" ]; then
                    rm -rf "$target_dir"
                fi

                # Copy theme to extensions directory
                cp -r "$theme_dir" "$target_dir"
                print_success "Installed theme: $theme_name"
            fi
        done
    fi
}

install_terminal_config() {
    print_header "Installing Terminal Configuration"

    # Terminal config is Windows-only
    if [[ "$OSTYPE" != "msys" ]] && [[ "$OSTYPE" != "win32" ]]; then
        print_warning "Terminal config is Windows-only, skipping."
        return
    fi

    # Windows Terminal
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        WT_DIR="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
        if [ -d "$WT_DIR" ] && [ -f "$DOTFILES_DIR/windows-terminal/settings.json" ]; then
            create_symlink "$DOTFILES_DIR/windows-terminal/settings.json" "$WT_DIR/settings.json"
        fi
    fi
}

# ============================================================================
# Main Installation
# ============================================================================

main() {
    print_header "Starting Dotfiles Installation"
    echo "Dotfiles directory: $DOTFILES_DIR"

    # On Linux, offer to install prerequisites
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        read -p "Check and install prerequisites (zsh, git, curl, Oh My Zsh)? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_dependencies
        fi
    fi

    # Prompt for what to install
    echo -e "\nWhat would you like to install?"
    echo "1) Everything"
    echo "2) Shell config only"
    echo "3) Git config only"
    echo "4) VSCode config only"
    echo "5) Terminal config only"
    echo "6) Custom selection"

    read -p "Enter your choice [1-6]: " choice

    case $choice in
        1)
            install_shell_config
            install_git_config
            install_vscode_config
            install_terminal_config
            ;;
        2)
            install_shell_config
            ;;
        3)
            install_git_config
            ;;
        4)
            install_vscode_config
            ;;
        5)
            install_terminal_config
            ;;
        6)
            read -p "Install shell config? [y/N]: " -n 1 -r install_shell
            echo
            read -p "Install git config? [y/N]: " -n 1 -r install_git
            echo
            read -p "Install VSCode config? [y/N]: " -n 1 -r install_vscode
            echo
            read -p "Install terminal config? [y/N]: " -n 1 -r install_terminal
            echo

            [[ $install_shell =~ ^[Yy]$ ]] && install_shell_config
            [[ $install_git =~ ^[Yy]$ ]] && install_git_config
            [[ $install_vscode =~ ^[Yy]$ ]] && install_vscode_config
            [[ $install_terminal =~ ^[Yy]$ ]] && install_terminal_config
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac

    print_header "Installation Complete!"
    echo -e "\nNext steps:"
    echo "  1. Update Git config with your name and email"
    echo "  2. Reload your shell: exec \$SHELL"
    echo "  3. Customize settings to your preference"
}

# Run main function
main
