# ~/.bashrc

## Prompt
__prompt_command() {
    local RETURN=$?

    local NOCOLOR="\033[0m"
    local RED="\033[0;31m"
    local GREEN="\033[0;32m"
    local YELLOW="\033[0;33m"
    local BLUE="\033[0;34m"
    
    local SYMBOL='❱'
    [[ $EUID -eq 0 ]] && SYMBOL='#'

    # [[ $? -eq 0 ]] \
    #     && USER_PROMPT="\[${GREEN}\]${SYMBOL}\[${NOCOLOR}\]" \
    #     || USER_PROMPT="\[${RED}\]$? ${SYMBOL}\[${NOCOLOR}\]"
    if [ $RETURN -eq 0 ]
    then
        USER_PROMPT="\[${GREEN}\]${SYMBOL}\[${NOCOLOR}\]"
    else
        USER_PROMPT="\[${RED}\]$? ${SYMBOL}\[${NOCOLOR}\]"
    fi
    
    # local GIT_BRANCH=$(git branch 2>/dev/null)
    local GIT_BRANCH=$(git branch --no-color 2> /dev/null | grep -m 1 ^\* | sed -e "s/\* \(.*\)/ \1/")
    GIT_INFO=""
    local GIT_INFO_COLOR="\[${GREEN}\]"
    local GIT_STATUS=$(git status --porcelain 2>/dev/null)

    [[ ! -z "$GIT_BRANCH" ]] && GIT_INFO="${GIT_BRANCH#* }" || GIT_INFO=""
    [[ ! -z "$GIT_STATUS" ]] && GIT_INFO_COLOR="\[${YELLOW}\]"
    [[ ! -z "$GIT_INFO" ]] && GIT_INFO=" ${GIT_INFO_COLOR}${GIT_INFO}"

    PS1="\[${BLUE}\]\w${GIT_INFO} ${USER_PROMPT} "
}

PROMPT_COMMAND=__prompt_command

PS4='-[\e[33m${BASH_SOURCE/.sh}\e[0m: \e[32m${LINENO}\e[0m] '
PS4+='${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Aliases
if command -v exa &> /dev/null
then
    alias ls=exa
fi
