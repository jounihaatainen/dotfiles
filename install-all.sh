#!/bin/sh

stow --dotfiles --target=$HOME bash
stow --dotfiles --target=$HOME bin
stow --dotfiles --target=$HOME git
stow --dotfiles --target=$HOME nvim
stow --dotfiles --target=$HOME starship
stow --dotfiles --target=$HOME tmux
