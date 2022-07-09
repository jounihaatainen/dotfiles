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
function apt_install_packages {
    echo "Install packages for Linux"
    
    ## Add repositories
    echo "--- Add repositories"
    sudo apt -y install software-properties-common
    sudo add-apt-repository -y ppa:fish-shell/release-3
    sudo add-apt-repository -y ppa:neovim-ppa/unstable

    ## Update and upgrade packages
    echo "--- Update and upgrade packages"
    sudo apt update && sudo apt -y upgrade

    ## Install packages
    echo "--- Install packages"
    sudo apt -y install build-essential fish neovim tmux fzf fd-find ripgrep bat exa jq httpie cmake clang llvm nodejs npm unzip
    # TODO: How to install these: git-delta glow slides lf ???

    ## Remove unnecessary packages
    echo "--- Auto remove unnecessary packages"
    sudo apt -y autoremove
}

function brew_install_packages {
    echo "Install packages for MacOS"

    ## Install Homebrew if not installed
    if ! command -v brew &> /dev/null
    then
        echo "Install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    ## Install wezterm
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm

    ## Install command line tools
    brew install fish nvim tmux fzf fd ripgrep bat git-delta glow slides exa lf jq httpie
    #brew install jrnl
    #brew install gh
    
    ## Install dependencies for LSP servers
    brew install cmake llvm node
}

echo "---"

case "$df_os" in
    Linux*) apt_install_packages ;;
    Darwin*) brew_install_packages ;;
    *) echo "Don't know what to install for $df_os" ;;
esac


# All done
cat << EOF
---
All done

You might want to change your default shell to fish with following command:
  chsh -s /usr/bin/fish
EOF
