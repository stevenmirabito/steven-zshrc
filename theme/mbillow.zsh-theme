HOSTNAME=$(hostname -f | tr '[:upper:]' '[:lower:]')

if [ $HOSTNAME = "mbillowmac1" ]; then
    SHELL_COLOR="red"
elif [ $HOSTNAME = "ada" ]; then
    SHELL_COLOR="magenta"
elif [ $HOSTNAME = "endor" ]; then
    SHELL_COLOR="green"
elif [ $HOSTNAME = "mwb3965" ]; then
    SHELL_COLOR="orange"
elif [ $HOSTNAME = "san" ]; then
    SHELL_COLOR="blue"
else
    SHELL_COLOR="white"
fi

PROMPT='%{$fg[$SHELL_COLOR]%}➜ %{$fg_bold[green]%}%p %{$fg_bold[white]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
