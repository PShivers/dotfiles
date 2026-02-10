# dotfiles

Personal configuration files for development environments across multiple machines.

## Overview

This repository contains my dotfiles for maintaining consistent development environments across different machines. It includes configurations for:

- Shell (Zsh with Oh My Zsh + Agnoster theme)
- Git
- VSCode
- GNOME Terminal (Rose Pine theme)
- Windows Terminal

## Structure

```text
dotfiles/
├── shell/              # Shell configuration files
│   └── .zshrc          # Zsh configuration
├── git/                # Git configuration
│   ├── .gitconfig      # Git config with aliases
│   └── .gitignore_global  # Global gitignore
├── gnome-terminal/     # GNOME Terminal configuration
│   └── rose-pine.dconf # Rose Pine color scheme
├── vscode/             # VSCode settings
│   ├── settings.json   # Editor settings
│   ├── keybindings.json  # Keyboard shortcuts
│   ├── extensions.txt  # List of extensions
│   └── themes/         # Custom themes
│       ├── catppuccin/       # Catppuccin theme
│       ├── catppuccin-icons/ # Catppuccin icons
│       └── sublime-monokai/  # Sublime Monokai theme
├── windows-terminal/   # Windows Terminal config
│   └── settings.json   # Terminal settings
├── install.sh          # Installation script
└── uninstall.sh        # Uninstallation script
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

- Check and install prerequisites (zsh, git, curl, micro, Oh My Zsh)
- Install MesloLGS NF font (required for Agnoster theme)
- Clone Oh My Zsh custom plugins (zsh-autosuggestions, zsh-syntax-highlighting, you-should-use)
- Set zsh as the default shell
- Backup any existing config files
- Create symlinks to the dotfiles
- Apply Rose Pine theme to GNOME Terminal (Linux)
- Optionally install VSCode extensions and themes

### Manual Installation

You can also manually symlink individual configs:

```bash
# Shell
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

# Git
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

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

The Zsh configuration uses Oh My Zsh with the **Agnoster** theme and includes:

- Agnoster prompt showing username and directory with Powerline segments
- **MesloLGS NF** font (installed automatically for Powerline glyphs)
- Sensible defaults for history
- Case-insensitive tab completion
- Helper functions (`mkcd`, `extract`)
- Platform-specific overrides via `~/.zshrc.local`

#### Oh My Zsh Plugins

- **git** - Git aliases and functions
- **docker** - Docker completions
- **kubectl** - Kubernetes completions
- **node** - Node.js helpers
- **npm** - npm completions
- **python** - Python helpers
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Syntax highlighting in the shell
- **you-should-use** - Reminds you to use existing aliases

### GNOME Terminal

The GNOME Terminal configuration applies the **Rose Pine** color scheme via a dconf file. It is automatically loaded by the install script on Linux systems with GNOME Terminal.

To manually apply:

```bash
PROFILE_ID=$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -1 | tr -d '/:')
dconf load "/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" < gnome-terminal/rose-pine.dconf
```

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

The install script automatically copies custom themes to your VSCode extensions directory.

### Windows Terminal

Windows Terminal settings are automatically detected on Windows. The configuration includes:

- Custom color scheme (One Half Dark)
- Font settings (Cascadia Code)
- Profile configurations for PowerShell, WSL, and Git Bash

## Shell Aliases

### Git Aliases (from .gitconfig)

- `git st` - Short status
- `git l` - One-line log with graph
- `git co` - Checkout
- `git cob` - Create and checkout new branch
- `git cm` - Commit with message
- `git unstage` - Unstage files
- `git undo` - Undo last commit (soft reset)

### Shell Aliases (from .zshrc)

- `..` - Go up one directory
- `py` - Python
- `pip` - Python pip
- `venv` - Create a Python venv
- `edit` / `m` - Open micro editor
- `rm`, `cp`, `mv` - Safety aliases with `-i` confirmation

### Functions

- `mkcd <dir>` - Create and enter directory
- `extract <file>` - Extract any common archive format

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

## Uninstalling

To remove dotfile symlinks and restore backups:

```bash
./uninstall.sh
```

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
