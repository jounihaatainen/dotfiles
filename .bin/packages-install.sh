#!/usr/bin/env bash

set -e

# Install packages
BREW_PACKAGES="fish starship nvim tmux fzf fd ripgrep bat git-delta glow slides exa lf jq jless httpie node"
BREW_LSP_SERVER_SUPPORT_PACKAGES="cmake llvm"
APT_LSP_SERVER_SUPPORT_PACKAGES="zlib1g-dev"

function brew_install_self_if_not_in_path {
    if ! command -v brew &> /dev/null
    then
        echo "Install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function post_install_actions {
    ## Rebuild theme cache for bat (so it finds new themes from /.config/bat/themes)
    ## All installed themes can be seen with: bat --list-themes
    bat cache --build

    ## Show app switcher on all displays
    defaults write com.apple.dock appswitcher-all-displays -bool true && killall Dock
}

function post_install_actions_macos {
    ## Show app switcher on all displays
    defaults write com.apple.dock appswitcher-all-displays -bool true && killall Dock
}

function install_packages_linux {
    ## Install Homebrew's dependencies
    echo "Install dependencies for Homebrew"
    sudo apt-get install build-essential

    ## Install Homebrew if not installed
    brew_install_self_if_not_in_path
    
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    ## Install command line tools
    echo "Install packages with Homebrew"
    brew install gcc $BREW_PACKAGES $BREW_LSP_SERVER_SUPPORT_PACKAGES

    ## Ensure that libz is available for language servers (mainly ccls)
    echo "Ensure that libz is available for language servers (mainly ccls)"
    sudo apt install $APT_LSP_SERVER_SUPPORT_PACKAGES

    ## Install bun
    brew tap oven-sh/bun
    brew install bun

    post_install_actions
}

function install_packages_macos {
    ## Install Homebrew if not installed
    brew_install_self_if_not_in_path

    echo "Install packages with Homebrew"

    ## Install wezterm
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm

    ## Install Hammerspoon
    brew install --cask hammerspoon

    ## Install qutebrowser
    brew install --cask qutebrowser

    ## Install Docker Desktop
    brew install --cask docker

    ## Install Inkscape
    brew install --cask inkscape

    ## Install Vial
    brew install --cask vial

    ## Install command line tools
    brew install $BREW_PACKAGES $BREW_LSP_SERVER_SUPPORT_PACKAGES

    ## Install bun
    brew tap oven-sh/bun
    brew install bun

    post_install_actions
    post_install_actions_macos
}

DOTFILES_OS="$(uname -s)"

case "$DOTFILES_OS" in
    Linux*) install_packages_linux ;;
    Darwin*) install_packages_macos ;;
    *) echo "Don't know what to install for ${DOTFILES_OS}. Abort, abort, abort!" ;;
esac

# All done
cat << EOF
---
Packages installed

You might want to change your default shell to
fish with something like following command:

  chsh -s /path/to/fish
EOF
