# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools and environments. The repository is organized into separate directories for each tool:

- **zsh/**: ZSH shell configuration with modular structure
- **emacs-doom/**: Doom Emacs configuration
- **emacs-personal/**: Personal Emacs configuration with custom packages
- **git/**: Git configuration
- **zed/**: Zed editor settings
- **pycharm/**: PyCharm IDE settings

## ZSH Configuration Architecture

The ZSH configuration follows a modular approach:

### Main Configuration Files
- `.zshrc` - Main entry point that sources other config files
- `.zmacos.zsh` - macOS-specific configurations (Homebrew, paths)
- `.zcustom.zsh` - User-specific custom configurations

### Modular Config Directory (`zsh/config/`)
- `aliases.zsh` - Command aliases and shortcuts
- `functions.zsh` - Custom shell functions
- `plugins.zsh` - ZSH plugins configuration
- `options.zsh` - ZSH shell options
- `fzf.zsh` - FZF fuzzy finder integration

### Environment Variables
The configuration relies on these environment variables:
- `ZDOTDIR` - ZSH configuration directory
- `ZSH_CONFIG_PATH` - Path to modular config files
- `ZSH_FUNC_PATH` - Custom functions path

## Key Custom Functions

### Alias Management
- `add-alias <name> <command>` - Add alias to aliases.zsh
- `add-custom-alias <name> <command>` - Add alias to .zcustom.zsh  
- `add-path-alias <name>` - Create alias for current directory
- `apply_zsh` - Reload ZSH configuration
- `apply_alias` - Reload just aliases

### Development Utilities  
- `npm` - Auto-detects pnpm vs npm based on package.json
- `gitignore <items>` - Append items to .gitignore
- `running <process>` - Find running processes
- `pipfind <package>` - Search pip installed packages

## Git Configuration

Uses hub as git wrapper (`alias git="hub"`). Key aliases:
- `gst` - git status
- `gpo` - push to origin current branch  
- `gpull` - pull from origin current branch
- `commit-push <msg>` - commit all changes and push

## Development Environment

- **Editor**: Zed (`EDITOR='zed'`, `VISUAL='zed'`)
- **Package Manager**: Uses `mise` for runtime version management
- **Java**: OpenJDK 17 via Homebrew
- **Python**: Conda environment configured
- **Tools**: bat (cat replacement), meld (diff tool), docker-compose