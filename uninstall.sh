#!/bin/bash

# ============================================================================
# Dotfiles Uninstallation Script
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

remove_symlink() {
    local target=$1

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        print_warning "$target does not exist, skipping"
        return
    fi

    # Only remove if it's a symlink pointing into the dotfiles directory
    if [ -L "$target" ]; then
        local link_dest
        link_dest="$(readlink "$target")"
        if [[ "$link_dest" == "$DOTFILES_DIR"* ]]; then
            rm "$target"
            print_success "Removed symlink $target"
        else
            print_warning "$target is a symlink but not managed by this dotfiles repo, skipping"
            return
        fi
    else
        print_warning "$target is a regular file (not a symlink), skipping"
        return
    fi

    # Restore most recent backup if one exists
    local target_dir
    target_dir="$(dirname "$target")"
    local target_base
    target_base="$(basename "$target")"
    local latest_backup
    latest_backup="$(ls -1t "${target_dir}/${target_base}.backup."* 2>/dev/null | head -n 1)"

    if [ -n "$latest_backup" ]; then
        mv "$latest_backup" "$target"
        print_success "Restored backup $latest_backup -> $target"
    fi
}

# ============================================================================
# Uninstallation Functions
# ============================================================================

uninstall_shell_config() {
    print_header "Removing Shell Configuration"

    remove_symlink "$HOME/.zshrc"
    remove_symlink "$HOME/.bashrc"
}

uninstall_git_config() {
    print_header "Removing Git Configuration"

    remove_symlink "$HOME/.gitconfig"
    remove_symlink "$HOME/.gitignore_global"
}

uninstall_vscode_config() {
    print_header "Removing VSCode Configuration"

    # Determine VSCode config directory
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        VSCODE_DIR="$APPDATA/Code/User"
    else
        VSCODE_DIR="$HOME/.config/Code/User"
    fi

    remove_symlink "$VSCODE_DIR/settings.json"
    remove_symlink "$VSCODE_DIR/keybindings.json"

    # Remove custom themes that were copied from this repo
    if [ -d "$DOTFILES_DIR/vscode/themes" ]; then
        VSCODE_EXT_DIR="$HOME/.vscode/extensions"

        for theme_dir in "$DOTFILES_DIR/vscode/themes"/*; do
            if [ -d "$theme_dir" ]; then
                theme_name=$(basename "$theme_dir")
                target_dir="$VSCODE_EXT_DIR/$theme_name"

                if [ -d "$target_dir" ]; then
                    rm -rf "$target_dir"
                    print_success "Removed theme: $theme_name"
                else
                    print_warning "Theme not installed: $theme_name"
                fi
            fi
        done
    fi
}

uninstall_terminal_config() {
    print_header "Removing Terminal Configuration"

    # Terminal config is Windows-only
    if [[ "$OSTYPE" != "msys" ]] && [[ "$OSTYPE" != "win32" ]]; then
        print_warning "Terminal config is Windows-only, skipping."
        return
    fi

    # Windows Terminal
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        WT_DIR="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
        if [ -d "$WT_DIR" ]; then
            remove_symlink "$WT_DIR/settings.json"
        fi
    fi
}

# ============================================================================
# Dependency Removal (Linux)
# ============================================================================

uninstall_dependencies() {
    print_header "Removing Dependencies"

    # Check for apt (Debian/Ubuntu)
    if ! command -v apt &> /dev/null; then
        print_warning "apt not found — dependency removal is only supported on Debian/Ubuntu"
        return
    fi

    # Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        read -p "Remove Oh My Zsh (~/.oh-my-zsh)? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.oh-my-zsh"
            print_success "Oh My Zsh removed"
        fi
    else
        print_success "Oh My Zsh is not installed"
    fi

    # Set default shell back to bash
    if command -v bash &> /dev/null; then
        current_shell=$(basename "$SHELL")
        if [ "$current_shell" != "bash" ]; then
            read -p "Switch default shell back to bash? [y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                chsh -s "$(which bash)"
                print_success "Default shell set to bash"
            fi
        else
            print_success "bash is already the default shell"
        fi
    fi

    # micro text editor
    if command -v micro &> /dev/null; then
        read -p "Uninstall micro text editor? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt remove -y micro
            print_success "micro removed"
        fi
    else
        print_success "micro is not installed"
    fi

    # zsh
    if command -v zsh &> /dev/null; then
        read -p "Uninstall zsh? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt remove -y zsh
            print_success "zsh removed"
        fi
    else
        print_success "zsh is not installed"
    fi
}

# ============================================================================
# Main Uninstallation
# ============================================================================

main() {
    print_header "Starting Dotfiles Uninstallation"
    echo "Dotfiles directory: $DOTFILES_DIR"

    # Prompt for what to uninstall
    echo -e "\nWhat would you like to uninstall?"
    echo "1) Everything"
    echo "2) Shell config only"
    echo "3) Git config only"
    echo "4) VSCode config only"
    echo "5) Terminal config only"
    echo "6) Custom selection"

    read -p "Enter your choice [1-6]: " choice

    case $choice in
        1)
            uninstall_shell_config
            uninstall_git_config
            uninstall_vscode_config
            uninstall_terminal_config
            ;;
        2)
            uninstall_shell_config
            ;;
        3)
            uninstall_git_config
            ;;
        4)
            uninstall_vscode_config
            ;;
        5)
            uninstall_terminal_config
            ;;
        6)
            read -p "Remove shell config? [y/N]: " -n 1 -r remove_shell
            echo
            read -p "Remove git config? [y/N]: " -n 1 -r remove_git
            echo
            read -p "Remove VSCode config? [y/N]: " -n 1 -r remove_vscode
            echo
            read -p "Remove terminal config? [y/N]: " -n 1 -r remove_terminal
            echo

            [[ $remove_shell =~ ^[Yy]$ ]] && uninstall_shell_config
            [[ $remove_git =~ ^[Yy]$ ]] && uninstall_git_config
            [[ $remove_vscode =~ ^[Yy]$ ]] && uninstall_vscode_config
            [[ $remove_terminal =~ ^[Yy]$ ]] && uninstall_terminal_config
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac

    # On Linux, offer to remove dependencies
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        read -p "Remove installed dependencies (Oh My Zsh, micro, zsh)? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            uninstall_dependencies
        fi
    fi

    print_header "Uninstallation Complete!"
    echo -e "\nYour dotfiles symlinks have been removed."
    echo "Any backup files that were found have been restored."
    echo "You may need to reload your shell: exec \$SHELL"
}

# Run main function
main
