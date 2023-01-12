if [[ -d "$HOME/.linuxbrew" ]]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv)
fi
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
