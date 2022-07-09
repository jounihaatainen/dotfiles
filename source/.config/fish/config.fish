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
    set --export BAT_THEME Dracula
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
        eval (/usr/libexec/java_home)
    end

    # Android
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/tools/bin
    fish_add_path $ANDROID_HOME/platform-tools
    fish_add_path $ANDROID_HOME/emulator

    # Dotnet
    fish_add_path ~/.dotnet/tools

    # Other
    fish_add_path ~/Google\ Drive/bin
end


# Abbreviations
if status is-interactive
    if type -q exa
        abbr ls 'exa'
        abbr ll 'exa -l -g --icons'
        abbr lla 'exa -a -l -g --icons'
    else
        abbr ls 'ls --color=auto'
        abbr ll 'ls --color=auto -l'
        abbr lla 'll -a'
    end
end

# Start ssh-agent if it is not running
if status is-interactive
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set --export SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set --export SSH_AGENT_PID $SSH_AGENT_PID
    end
end
