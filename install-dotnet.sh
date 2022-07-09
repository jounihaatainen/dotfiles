#!/usr/bin/env bash

set -e

df_os="$(uname -s)"

function apt_install_packages {
    echo "Install dotnet packages with apt on Linux"

    ## Add repository
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    ## Install dotnet-sdk
    echo "--- Install dotnet-sdk"
    sudo apt update; \
        sudo apt install -y apt-transport-https && \
        sudo apt update && \
        sudo apt install -y dotnet-sdk-6.0
}

function brew_install_packages {
    echo "Install dotnet packages with homebrew on MacOS"

    ## Install Homebrew if not installed
    if ! command -v brew &> /dev/null
    then
        echo "--- Install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    ## Install dotnet-sdk
    echo "--- Install dotnet-sdk"
    brew install --cask dotnet-sdk
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
EOF
