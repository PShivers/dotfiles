# dotfiles

Personal configuration files for development environments across multiple machines.

## Overview

This repository contains my dotfiles for maintaining consistent development environments across different machines. It includes configurations for:

- Shell (Zsh with Oh My Zsh)
- Git
- VSCode
- Micro editor
- Windows Terminal

## Structure

```text
dotfiles/
├── shell/              # Shell configuration files
│   └── .zshrc          # Zsh configuration (Oh My Zsh)
├── git/                # Git configuration
│   ├── .gitconfig      # Git config with aliases
│   └── .gitignore_global  # Global gitignore
├── vscode/             # VSCode settings
│   ├── settings.json   # Editor settings
│   ├── keybindings.json  # Keyboard shortcuts
│   ├── extensions.txt  # List of extensions
│   └── themes/         # Custom themes
│       ├── catppuccin/       # Catppuccin theme
│       ├── catppuccin-icons/ # Catppuccin icons
│       └── sublime-monokai/  # Sublime Monokai theme
├── micro/              # Micro editor config
│   ├── settings.json   # Editor settings
│   └── bindings.json   # Key bindings
├── windows-terminal/   # Windows Terminal config
│   └── settings.json   # Terminal settings
└── install.sh          # Installation script
```

## Installation

### Quick Install

Clone this repository and run the install script:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script will:

- Backup any existing config files
- Create symlinks to the dotfiles
- Optionally install VSCode extensions

### Manual Installation

You can also manually symlink individual configs:

```bash
# Shell
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

# Git
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

# Micro editor
mkdir -p ~/.config/micro
ln -s ~/.dotfiles/micro/settings.json ~/.config/micro/settings.json
ln -s ~/.dotfiles/micro/bindings.json ~/.config/micro/bindings.json

# VSCode (location varies by OS)
# Linux: ~/.config/Code/User/
# macOS: ~/Library/Application Support/Code/User/
# Windows: %APPDATA%\Code\User\
```

## Configuration

### Git

After installation, update your Git user information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Zsh

The Zsh configuration uses Oh My Zsh with the agnoster theme. Features include:

- Oh My Zsh with agnoster theme
- NVM (Node Version Manager) integration
- Homebrew (Linuxbrew) integration
- Alias for micro editor (`m`)
- Support for machine-specific config via `.zshrc.local`

**Prerequisites:** Install Oh My Zsh first:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Micro Editor

The [micro](https://micro-editor.github.io/) configuration includes:

- Custom key bindings for commenting (`Alt-/` and `Ctrl+_`)

### VSCode

The VSCode configuration includes personal settings, keybindings, a curated list of extensions, and custom themes.

To install all extensions from [vscode/extensions.txt](vscode/extensions.txt):

```bash
cat vscode/extensions.txt | grep -v '^#' | grep -v '^$' | xargs -L 1 code --install-extension
```

#### Custom Themes

The [vscode/themes/](vscode/themes/) directory contains custom theme files. Currently includes:

- **Catppuccin** - Soothing pastel theme with 4 variants (Latte, Frappé, Macchiato, Mocha)
- **Catppuccin Icons** - Matching icon theme
- **Sublime Monokai** - A faithful recreation of Sublime Text's Monokai theme

The install script automatically copies custom themes to your VSCode extensions directory. To manually install a theme:

```bash
cp -r vscode/themes/catppuccin ~/.vscode/extensions/
cp -r vscode/themes/catppuccin-icons ~/.vscode/extensions/
cp -r vscode/themes/sublime-monokai ~/.vscode/extensions/
```

### Windows Terminal

Windows Terminal settings are automatically detected on Windows. The configuration includes:

- Custom color scheme (One Half Dark)
- Font settings (Cascadia Code)
- Profile configurations for PowerShell, WSL, and Git Bash

## Customization

### Platform-Specific Settings

Create a `.zshrc.local` file in your home directory for machine-specific configurations:

```bash
echo "export PATH=\"/custom/path:\$PATH\"" > ~/.zshrc.local
```

This file is sourced by the main `.zshrc` and is ignored by git.

### Adding New Configs

1. Add your config file to the appropriate directory
2. Update [install.sh](install.sh) to symlink the new config
3. Document it in this README

## Useful Aliases

### Git Aliases (from .gitconfig)

- `git st` - Short status
- `git l` - One-line log with graph
- `git co` - Checkout
- `git cob` - Create and checkout new branch
- `git cm` - Commit with message
- `git unstage` - Unstage files
- `git undo` - Undo last commit (soft reset)

### Shell Aliases (from .zshrc)

- `m` - Micro editor

## Updating

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## Backup

Before making major changes, the install script automatically backs up existing configs with timestamps:

```text
~/.zshrc.backup.20260124_153000
```

## Contributing

This is a personal dotfiles repository, but feel free to:

- Fork it and adapt it for your own use
- Open issues for bugs
- Submit PRs for improvements

## License

MIT License - Feel free to use and modify as needed.

## Credits

Inspired by the dotfiles community and various configurations from:

- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Paul Irish's dotfiles](https://github.com/paulirish/dotfiles)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
