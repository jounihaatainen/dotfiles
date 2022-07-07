# ~/.bashrc

## Prompt
prompt_command() {
  dir='~'
  [[ $PWD == $HOME ]] || dir="${PWD/$HOME/~}"
  branch=$(git branch 2>/dev/null)
  tag=$(git tag 2>/dev/null)

  [[ $EUID -eq 0 ]] && symbol='#' || symbol='❱'

  [[ ! -z "$branch" ]] && git_info="${branch#* }" || git_info=""
  [[ ! -z "$tag" ]] && git_info="${git_info} ($tag)"

  if [ -z "$git_info" ]
  then
    printf '\e[34m%s \e[0m' \
      "$dir"
  else
    printf '\e[34m%s \e[33m%s \e[0m' \
      "$dir" "$git_info"
  fi
}

PROMPT_COMMAND=prompt_command

PS1="\$([[ \$? -eq 0 ]] && printf '\[\e[32m\]%s\[\e[m\] ' "\$symbol" || \
  printf '\[\e[31m\]%s\[\e[0m\] ' "\$symbol")"

PS4='-[\e[33m${BASH_SOURCE/.sh}\e[0m: \e[32m${LINENO}\e[0m] '
PS4+='${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Aliases
if command -v exa &> /dev/null
then
    alias ls=exa
fi
