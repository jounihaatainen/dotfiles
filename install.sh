#!/usr/bin/env bash

set -e

df_dir="$(dirname "$(readlink -f "$0")")"
df_src_dir="${df_dir}/source"
df_bak_dir="${df_dir}/backup"
df_os="$(uname -s)"

echo "Running on '${df_os}'"
echo "Dotfiles in '${df_dir}'"
echo "Dotfiles source in '${df_src_dir}'"
echo "Backup directory in '${df_bak_dir}'"


# Backup existing regular files to backup folder before creating symlinks
cat << EOF
---
Backing up already existing regular files
EOF

cd "${df_src_dir}"
for f in $(find . -type f -xtype f -print | cut -c3-)
do
    if [ -f "${HOME}/$f" ] && [ ! -L "${HOME}/$f" ]
    then
	d=$(dirname "${df_bak_dir}/$f")
	[ ! -d "$d" ] && echo "Creating backup dir $d" && mkdir -p "$d"
        echo "Backing up \"${HOME}/$f\" to \"${df_bak_dir}/$f\""
	cp "${HOME}/$f" "${df_bak_dir}/$f"
    fi
done
cd - > /dev/null


# Create symlinks
cat << EOF
---
Creating symlinks
EOF

cd "${df_src_dir}"
for f in $(find . -type f -print | cut -c3-)
do
    d=$(dirname "${HOME}/$f")
    [ ! -d "$d" ] && echo "Creating dir $d" && mkdir -p "$d"
    echo "Creating link \"${HOME}/$f\" -> \"${df_src_dir}/$f\""
    ln -fs "${df_src_dir}/$f" "${HOME}/$f"
done
cd - > /dev/null

# Remove dead symlinks
cat << EOF
---
Finding dead symlinks (please remove following dead symlinks)
EOF

find "${HOME}" -maxdepth 1 -xtype l -print
[ -d "${HOME}/.config" ] && find "${HOME}/.config" -xtype l -print


# Install packages
BREW_PACKAGES="fish nvim tmux fzf fd ripgrep bat git-delta glow slides exa lf jq httpie"
BREW_LSP_SERVER_SUPPORT_PACKAGES="cmake llvm node"
APT_LSP_SERVER_SUPPORT_PACKAGES="zlib1g-dev"

function brew_install_self_if_not_in_path {
    if ! command -v brew &> /dev/null
    then
        echo "Install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function brew_install_packages_linux {
    echo "Install packages with Homebrew on Linux"

    ## Install Homebrew's dependencies
    sudo apt-get install build-essential

    ## Ensure that libz is available for language servers (mainly ccls)
    sudo apt install $APT_LSP_SERVER_SUPPORT_PACKAGES

    ## Install Homebrew if not installed
    brew_install_self_if_not_in_path
    
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    ## Install command line tools
    brew install gcc $BREW_PACKAGES $BREW_LSP_SERVER_SUPPORT_PACKAGES
}

function brew_install_packages_macos {
    echo "Install packages with Homebrew on MacOS"

    ## Install Homebrew if not installed
    brew_install_self_if_not_in_path

    ## Install wezterm
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm

    ## Install command line tools
    brew install $BREW_PACKAGES $BREW_LSP_SERVER_SUPPORT_PACKAGES
}

echo "---"

case "$df_os" in
    Linux*) brew_install_packages_linux ;;
    Darwin*) brew_install_packages_macos ;;
    *) echo "Don't know what to install for $df_os" ;;
esac


# All done
cat << EOF
---
All done

You might want to change your default shell to fish with following command:
  chsh -s /usr/bin/fish
EOF
