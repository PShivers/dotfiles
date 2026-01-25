# Dotfiles Architecture

This document visualizes the structure and relationships within this dotfiles repository.

## Repository Structure

```mermaid
graph TB
    subgraph "Dotfiles Repository"
        ROOT[dotfiles/]

        subgraph "Configuration Files"
            SHELL[shell/.zshrc]
            GIT_CONFIG[git/.gitconfig]
            GIT_IGNORE[git/.gitignore_global]
            VS_SETTINGS[vscode/settings.json]
            VS_KEYS[vscode/keybindings.json]
            VS_EXT[vscode/extensions.txt]
            WT_SETTINGS[windows-terminal/settings.json]
        end

        subgraph "Custom Themes"
            THEME_CAT[vscode/themes/catppuccin/]
            THEME_CAT_ICONS[vscode/themes/catppuccin-icons/]
            THEME_MONOKAI[vscode/themes/sublime-monokai/]
        end

        subgraph "Scripts"
            INSTALL[install.sh]
        end

        subgraph "Documentation"
            README[README.md]
            CLAUDE[claude.md]
            ARCH[ARCHITECTURE.md]
        end

        ROOT --> SHELL
        ROOT --> GIT_CONFIG
        ROOT --> GIT_IGNORE
        ROOT --> VS_SETTINGS
        ROOT --> VS_KEYS
        ROOT --> VS_EXT
        ROOT --> WT_SETTINGS
        ROOT --> THEME_CAT
        ROOT --> THEME_CAT_ICONS
        ROOT --> THEME_MONOKAI
        ROOT --> INSTALL
        ROOT --> README
        ROOT --> CLAUDE
        ROOT --> ARCH
    end
```

## Installation Flow

```mermaid
flowchart TD
    START([New Machine]) --> CLONE[Clone Repository]
    CLONE --> RUN_INSTALL[Run install.sh]

    RUN_INSTALL --> CHOICE{Select Installation Type}

    CHOICE -->|1. Everything| ALL[Install All Configs]
    CHOICE -->|2. Shell Only| SHELL_ONLY[Install Shell Config]
    CHOICE -->|3. Git Only| GIT_ONLY[Install Git Config]
    CHOICE -->|4. VSCode Only| VS_ONLY[Install VSCode Config]
    CHOICE -->|5. Terminal Only| TERM_ONLY[Install Terminal Config]
    CHOICE -->|6. Custom| CUSTOM[Custom Selection]

    ALL --> SHELL_INSTALL[Symlink .zshrc]
    ALL --> GIT_INSTALL[Symlink .gitconfig & .gitignore_global]
    ALL --> VS_INSTALL[Install VSCode]
    ALL --> TERM_INSTALL[Symlink Windows Terminal settings]

    SHELL_ONLY --> SHELL_INSTALL
    GIT_ONLY --> GIT_INSTALL
    VS_ONLY --> VS_INSTALL
    TERM_ONLY --> TERM_INSTALL
    CUSTOM --> SHELL_INSTALL
    CUSTOM --> GIT_INSTALL
    CUSTOM --> VS_INSTALL
    CUSTOM --> TERM_INSTALL

    VS_INSTALL --> VS_SYMLINK[Symlink settings.json & keybindings.json]
    VS_SYMLINK --> VS_EXT_INSTALL[Install Extensions from extensions.txt]
    VS_EXT_INSTALL --> VS_THEME_INSTALL[Copy Custom Themes to ~/.vscode/extensions/]

    SHELL_INSTALL --> SHELL_MANUAL{Manual Steps Needed}
    SHELL_MANUAL --> INSTALL_ZSH[sudo apt install zsh]
    INSTALL_ZSH --> CHSH[chsh -s $\(which zsh\)]
    CHSH --> INSTALL_OMZ[Install Oh My Zsh]

    GIT_INSTALL --> GIT_MANUAL{Manual Steps Needed}
    GIT_MANUAL --> GIT_USER[Configure Git user.name & user.email]

    SHELL_MANUAL --> COMPLETE([Installation Complete])
    GIT_MANUAL --> COMPLETE
    VS_THEME_INSTALL --> COMPLETE
    TERM_INSTALL --> COMPLETE
```

## File Symlink Mapping

```mermaid
graph LR
    subgraph "Dotfiles Repo"
        SRC_ZSHRC[shell/.zshrc]
        SRC_GIT[git/.gitconfig]
        SRC_GITIGNORE[git/.gitignore_global]
        SRC_VS_SETTINGS[vscode/settings.json]
        SRC_VS_KEYS[vscode/keybindings.json]
        SRC_WT[windows-terminal/settings.json]
    end

    subgraph "Home Directory"
        HOME_ZSHRC[~/.zshrc]
        HOME_GIT[~/.gitconfig]
        HOME_GITIGNORE[~/.gitignore_global]
    end

    subgraph "VSCode User Directory"
        VS_SETTINGS[settings.json]
        VS_KEYS[keybindings.json]
    end

    subgraph "VSCode Extensions"
        EXT_CAT[catppuccin/]
        EXT_CAT_ICONS[catppuccin-icons/]
        EXT_MONOKAI[sublime-monokai/]
    end

    subgraph "Windows Terminal"
        WT_SETTINGS[LocalState/settings.json]
    end

    SRC_ZSHRC -.symlink.-> HOME_ZSHRC
    SRC_GIT -.symlink.-> HOME_GIT
    SRC_GITIGNORE -.symlink.-> HOME_GITIGNORE
    SRC_VS_SETTINGS -.symlink.-> VS_SETTINGS
    SRC_VS_KEYS -.symlink.-> VS_KEYS
    SRC_WT -.symlink.-> WT_SETTINGS

    THEME_CAT[vscode/themes/catppuccin/] -.copy.-> EXT_CAT
    THEME_CAT_ICONS[vscode/themes/catppuccin-icons/] -.copy.-> EXT_CAT_ICONS
    THEME_MONOKAI[vscode/themes/sublime-monokai/] -.copy.-> EXT_MONOKAI
```

## VSCode Theme Customization Flow

```mermaid
flowchart TD
    START([User Changes Theme]) --> CHECK{Which Theme?}

    CHECK -->|Sublime Monokai| MONO_COLORS[Apply Yellow Accent #cbad2a]
    CHECK -->|Catppuccin Mocha| MOCHA_COLORS[Apply Mauve #cba6f7]
    CHECK -->|Catppuccin Frappé| FRAPPE_COLORS[Apply Mauve #ca9ee6]
    CHECK -->|Catppuccin Macchiato| MACCHIATO_COLORS[Apply Mauve #c6a0f6]
    CHECK -->|Catppuccin Latte| LATTE_COLORS[Apply Purple #8839ef]

    MONO_COLORS --> APPLY[Apply Theme-Scoped Colors]
    MOCHA_COLORS --> APPLY
    FRAPPE_COLORS --> APPLY
    MACCHIATO_COLORS --> APPLY
    LATTE_COLORS --> APPLY

    APPLY --> TAB_ACTIVE[tab.activeBackground<br/>tab.activeBorder<br/>tab.activeBorderTop<br/>tab.activeForeground]
    APPLY --> TAB_INACTIVE[tab.inactiveBackground<br/>tab.hoverBackground]
    APPLY --> STATUS[statusBar.background<br/>statusBar.border]

    TAB_ACTIVE --> RESULT([Consistent UI Across Themes])
    TAB_INACTIVE --> RESULT
    STATUS --> RESULT
```

## Dependency Graph

```mermaid
graph TD
    subgraph "External Dependencies"
        ZSH[Zsh Shell]
        OMZ[Oh My Zsh]
        GIT[Git]
        VSCODE[VSCode]
        WT[Windows Terminal]
        CODE_CLI[code CLI]
    end

    subgraph "Repository Components"
        ZSHRC[.zshrc]
        GITCONFIG[.gitconfig]
        VS_CONFIG[VSCode Config]
        WT_CONFIG[Windows Terminal Config]
        INSTALL_SCRIPT[install.sh]
    end

    ZSHRC -.requires.-> ZSH
    ZSHRC -.optional.-> OMZ
    GITCONFIG -.requires.-> GIT
    VS_CONFIG -.requires.-> VSCODE
    VS_CONFIG -.requires for extensions.-> CODE_CLI
    WT_CONFIG -.requires.-> WT

    INSTALL_SCRIPT --> ZSHRC
    INSTALL_SCRIPT --> GITCONFIG
    INSTALL_SCRIPT --> VS_CONFIG
    INSTALL_SCRIPT --> WT_CONFIG
```

## Configuration Relationships

```mermaid
erDiagram
    DOTFILES ||--o{ SHELL_CONFIG : contains
    DOTFILES ||--o{ GIT_CONFIG : contains
    DOTFILES ||--o{ VSCODE_CONFIG : contains
    DOTFILES ||--o{ TERMINAL_CONFIG : contains

    VSCODE_CONFIG ||--o{ THEMES : includes
    VSCODE_CONFIG ||--o{ EXTENSIONS : lists
    VSCODE_CONFIG ||--|| SETTINGS : has
    VSCODE_CONFIG ||--|| KEYBINDINGS : has

    SETTINGS ||--o{ THEME_CUSTOMIZATIONS : defines
    THEME_CUSTOMIZATIONS }o--|| THEME : "applies to"

    SHELL_CONFIG ||--o{ OMZ_PLUGINS : configures
    SHELL_CONFIG ||--o{ ALIASES : defines
    SHELL_CONFIG ||--o{ FUNCTIONS : defines

    GIT_CONFIG ||--o{ GIT_ALIASES : defines
    GIT_CONFIG ||--|| GITIGNORE_GLOBAL : references
```
