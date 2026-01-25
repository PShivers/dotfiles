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

    # Windows Terminal
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        WT_DIR="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
        if [ -d "$WT_DIR" ] && [ -f "$DOTFILES_DIR/windows-terminal/settings.json" ]; then
            create_symlink "$DOTFILES_DIR/windows-terminal/settings.json" "$WT_DIR/settings.json"
        fi
    fi
}

install_micro_config() {
    print_header "Installing Micro Editor Configuration"

    MICRO_DIR="$HOME/.config/micro"
    mkdir -p "$MICRO_DIR"

    if [ -f "$DOTFILES_DIR/micro/settings.json" ]; then
        create_symlink "$DOTFILES_DIR/micro/settings.json" "$MICRO_DIR/settings.json"
    fi

    if [ -f "$DOTFILES_DIR/micro/bindings.json" ]; then
        create_symlink "$DOTFILES_DIR/micro/bindings.json" "$MICRO_DIR/bindings.json"
    fi
}

# ============================================================================
# Main Installation
# ============================================================================

main() {
    print_header "Starting Dotfiles Installation"
    echo "Dotfiles directory: $DOTFILES_DIR"

    # Prompt for what to install
    echo -e "\nWhat would you like to install?"
    echo "1) Everything"
    echo "2) Shell config only"
    echo "3) Git config only"
    echo "4) VSCode config only"
    echo "5) Terminal config only"
    echo "6) Micro editor config only"
    echo "7) Custom selection"

    read -p "Enter your choice [1-7]: " choice

    case $choice in
        1)
            install_shell_config
            install_git_config
            install_vscode_config
            install_terminal_config
            install_micro_config
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
            install_micro_config
            ;;
        7)
            read -p "Install shell config? [y/N]: " -n 1 -r shell
            echo
            read -p "Install git config? [y/N]: " -n 1 -r git
            echo
            read -p "Install VSCode config? [y/N]: " -n 1 -r vscode
            echo
            read -p "Install terminal config? [y/N]: " -n 1 -r terminal
            echo
            read -p "Install micro editor config? [y/N]: " -n 1 -r micro
            echo

            [[ $shell =~ ^[Yy]$ ]] && install_shell_config
            [[ $git =~ ^[Yy]$ ]] && install_git_config
            [[ $vscode =~ ^[Yy]$ ]] && install_vscode_config
            [[ $terminal =~ ^[Yy]$ ]] && install_terminal_config
            [[ $micro =~ ^[Yy]$ ]] && install_micro_config
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
