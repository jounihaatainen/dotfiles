# Environment variables
if status is-login
    # Default editor
    set --export EDITOR (which nvim)
    set --export VISUAL $EDITOR
    set --export SUDO_EDITOR $EDITOR
    
    # Android
    set --export ANDROID $HOME/Library/Android;
    set --export ANDROID_HOME $ANDROID/sdk;
    
    # Themes
    set --export BAT_THEME "Catppuccin-frappe"
end

# Path
if status is-login
    # Homebrew
    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end
    
    if test -x $HOME/.linuxbrew/bin/brew
        eval ($HOME/.linuxbrew/bin/brew shellenv)
    end

    if test -x /home/linuxbrew/.linuxbrew/bin/brew
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    end

    # Java
    if test -x /usr/libexec/java_home
        fish_add_path (/usr/libexec/java_home)
    end

    # Android
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/tools/bin
    fish_add_path $ANDROID_HOME/platform-tools
    fish_add_path $ANDROID_HOME/emulator

    # Dotnet
    fish_add_path ~/.dotnet/tools

    # Other
    fish_add_path ~/.bin
    fish_add_path ~/Google\ Drive/bin
end


# Abbreviations & aliases
if status is-interactive
    if type -q exa
        abbr ls 'exa'
        abbr ll 'exa -l -g --icons'
        abbr lla 'exa -a -l -g --icons'
        abbr tree 'exa --tree'
    else
        abbr ls 'ls --color=auto'
        abbr ll 'ls --color=auto -l'
        abbr lla 'll -a'
    end

    # Reload fish config
    abbr reload 'source ~/.config/fish/config.fish'

    # cd into directory with fzf
    abbr fcd 'cd (fd -td . | fzf --height 40%)'
    
    # Edit stuff with neovim
    abbr v 'nvim'
    abbr fv 'nvim (fzf -m --height 40%)'
   
    # Edit neovim configuration with neovim
    abbr vconf 'nvim $HOME/.config/nvim'

    # tmux shortcuts
    abbr tp 'tmux-projectizer'
    abbr ts 'tmux-switch'

    # Edit personal & work projects and project files with neovim
    abbr cdp 'cd (fd -td -d1 . --search-path $HOME/Documents/personal --search-path $HOME/Documents/work | fzf -m --height 40%)'
    abbr vp 'cd (fd -td -d1 . --search-path $HOME/Documents/personal --search-path $HOME/Documents/work | fzf -m --height 40%) && nvim .'
    abbr vpf 'nvim (fd . --search-path $HOME/Documents/personal --search-path $HOME/Documents/work | fzf -m --height 40%)'

    # Edit note files with neovim
    abbr vn 'nvim (fd -tf . $HOME/Google\ Drive/Documents/Notes | fzf -m --height 40%)'

    # Git with my dotfiles
    abbr dotfiles '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
end

# Start ssh-agent if it is not running
if status is-interactive
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set --export SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set --export SSH_AGENT_PID $SSH_AGENT_PID
    end
end

set fish_greeting (set_color red)'                 ___
   ___======____='(set_color yellow)'---='(set_color red)')
 /T            \_'(set_color yellow)'--==='(set_color red)')
 L \ '(set_color yellow)'(@)   '(set_color red)'\~    \_'(set_color yellow)'-=='(set_color red)')
  \      / )J'(set_color yellow)'~~    '(set_color red)'\\'(set_color yellow)'-='(set_color red)')
   \\\\___/  )JJ'(set_color yellow)'~~    '(set_color red)'\)
    \_____/JJJ'(set_color yellow)'~~      '(set_color red)'\
    / \  , \\'(set_color red)'J'(set_color yellow)'~~~~      \
   (-\)'(set_color red)'\='(set_color yellow)'|  \~~~        L__
   ('(set_color red)'\\'(set_color yellow)'\\)  ( -\)_            ==__
    '(set_color red)'\V    '(set_color yellow)'\-'(set_color red)'\) =='(set_color yellow)'=_____  J\   \\\\
           '(set_color red)'\V)     \_)'(set_color yellow)' \   JJ J\)
                       /J J'(set_color red)'T'(set_color yellow)'\JJJ'(set_color red)'J)
                       (J'(set_color yellow)'JJ| '(set_color red)'\UUU)
                        (UU)'

starship init fish | source
