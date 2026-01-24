# Claude Context: Dotfiles Repository

This file contains context about this dotfiles repository for Claude Code sessions.

## Repository Overview

Personal dotfiles for maintaining consistent development environments across machines. Primary focus is Windows development with WSL integration.

## Key Files & Configurations

### VSCode Settings (`vscode/settings.json`)

**Custom Theme Customizations:**
- Theme-scoped color customizations for tab UI elements
- Each theme (Sublime Monokai, Catppuccin variants) has matching colors for:
  - `tab.activeBackground`, `tab.activeBorder`, `tab.activeBorderTop`, `tab.activeForeground`
  - `tab.inactiveBackground`, `tab.hoverBackground`
  - `statusBar.background`, `statusBar.border`
- Colors are sourced from each theme's official palette to ensure consistency
- Sublime Monokai uses custom yellow accent: `#cbad2a`

**Token Color Customizations:**
- JavaScript-specific syntax highlighting for Sublime Monokai theme
- Custom styles for JSX, variables, constants, template strings

### Zsh Configuration (`shell/.zshrc`)

**Current State:**
- Oh My Zsh integration is ENABLED (uncommented in lines 128-129)
- Plugins: git, docker, kubectl, node, npm, python
- Includes custom aliases, functions (mkcd, extract)
- Sources `.zshrc.local` if it exists for machine-specific configs

**Important Notes:**
- The install script does NOT install zsh or set it as default shell
- After install, user must manually:
  1. Install zsh: `sudo apt install zsh` (in WSL)
  2. Set as default: `chsh -s $(which zsh)`
  3. Optional: Update Windows Terminal default profile to Ubuntu

### Git Configuration (`git/.gitconfig`)

- User info and core settings configured
- Default editor set to `micro`
- Many git aliases defined but COMMENTED OUT (lines 30-81)
- Global gitignore configured

### Windows Terminal (`windows-terminal/settings.json`)

- Default profile: PowerShell (`{574e775e-4f2a-5b96-ac1e-a2962a402336}`)
- Profiles: PowerShell, Ubuntu (WSL), Git Bash
- Color scheme: One Half Dark
- Font: Cascadia Code, size 11

## Installation Script (`install.sh`)

**What it does:**
- Creates symlinks for dotfiles (backs up existing files with timestamps)
- Installs VSCode extensions from `vscode/extensions.txt`
- Copies custom themes to VSCode extensions directory
- Supports selective installation (all, shell only, git only, etc.)

**What it does NOT do:**
- Install zsh or any shell
- Run `chsh` to change default shell
- Modify Windows Terminal default profile
- Install Oh My Zsh

## Git Ignore

- `.claude/` directory is ignored via `.gitignore`
- `.claude/settings.local.json` was previously tracked but has been removed

## Custom Themes

Located in `vscode/themes/`:
- `catppuccin/` - Catppuccin theme (4 variants: Latte, Frappé, Macchiato, Mocha)
- `catppuccin-icons/` - Catppuccin icon theme
- `sublime-monokai/` - Sublime Monokai theme

## Workflow Notes

**When adding new theme customizations:**
- Add theme-scoped entries to `workbench.colorCustomizations`
- Extract colors from the theme's official color palette (found in `vscode/themes/{theme}/themes/*.json`)
- Use the theme's accent color for borders and active elements

**Common Tasks:**
- Update VSCode settings: Edit `vscode/settings.json`, changes sync via symlink
- Add git aliases: Uncomment or add to `git/.gitconfig` aliases section
- Machine-specific shell config: Use `~/.zshrc.local` (not tracked)

## Current State (as of 2026-01-24)

- Repository initialized with basic dotfiles
- VSCode theme customizations configured for multiple themes
- `.claude/` directory excluded from version control
- Oh My Zsh enabled in `.zshrc` but not yet installed
- Git user info configured
- Recent commits focused on theme customizations and cleanup

## Extension List

VSCode extensions defined in `vscode/extensions.txt`:
- Themes: Catppuccin, various Monokai variants, One Dark variants, Synthwave
- Formatters: Prettier, ESLint, EditorConfig
- Git: GitLens
- AI: Claude Code, GitHub Copilot, ChatGPT
- Languages: Angular, Tailwind, GraphQL, Python, C/C++, Jupyter
- Tools: Docker, WSL, Live Server, Markdown

## Future Considerations

- Add shell detection/installation to `install.sh`
- Document Windows Terminal profile switching
- Consider adding theme customizations for other installed themes (One Dark, Synthwave, etc.)
