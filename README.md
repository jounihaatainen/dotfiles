# Dotfiles

This repository contains my dotfiles.

## Installation

`git` and `stow` are required for a smooth installation of these dotfiles.

For example install neovim configuration with `stow`:

```bash
git clone https://github.com/jounihaatainen/dotfiles.git
cd dotfiles
stow --dotfiles --target=$HOME nvim
```

## TODO

- When stow v2.4.0 is available:
    - Change alacritty/.config/ to  alacritty/dot-config/
    - Change nvim/.config/ to  nvim/dot-config/
    - Discussed in [https://github.com/aspiers/stow/issues/33](this issue)
