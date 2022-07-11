function weather --description 'Weather for city (default city is Pori)'
    set -l city = $argv[1]
    if test -z "$city"
        set city = "Pori"
    end
    curl -s wttr.in/$city | grep -v Follow
end
