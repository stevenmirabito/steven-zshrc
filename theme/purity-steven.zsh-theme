# Purity
# by Kevin Lanni
# https://github.com/therealklanni/purity
# MIT License

# Modified by Steven Mirabito
# https://github.com/stevenmirabito/steven-zshrc

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => foreground color dict
# %f => reset foreground color
# %K => background color dict
# %k => reset background color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

prompt_purity_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
prompt_purity_human_time() {
	local tmp=$1
	local days=$(( tmp / 60 / 60 / 24 ))
	local hours=$(( tmp / 60 / 60 % 24 ))
	local minutes=$(( tmp / 60 % 60 ))
	local seconds=$(( tmp % 60 ))
	echo -n "⌚︎ "
	(( $days > 0 )) && echo -n "${days}d "
	(( $hours > 0 )) && echo -n "${hours}h "
	(( $minutes > 0 )) && echo -n "${minutes}m "
	echo "${seconds}s"
}

prompt_purity_cmd_exec_time() {
	local stop=$EPOCHSECONDS
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${PURITY_CMD_MAX_EXEC_TIME:=5})) && prompt_purity_human_time $elapsed
}

prompt_purity_preexec() {
	cmd_timestamp=$EPOCHSECONDS

	# shows the current dir and executed command in the title when a process is active
	print -Pn "\e]0;"
	echo -nE "$PWD:t: $2"
	print -Pn "\a"
}

# string length ignoring ansi escapes
prompt_purity_string_length() {
	echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

prompt_purity_git_dirty() {
	# Adapted from: https://github.com/oh-my-fish/theme-cmorrell.com/blob/master/fish_right_prompt.fish
	if command git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
	    DIRTY=`command git status -s --ignore-submodules=dirty | wc -l | sed -e 's/^ *//' -e 's/ *$//' 2> /dev/null`
	    
	    if [[ "${DIRTY}" -ne "0" ]]; then
	    	echo -ne "%F{red}${DIRTY} changed file"
	    	if [[ "${DIRTY}" -ne "1" ]]; then
	    		echo -ne "s"
	      	fi
	    	echo -ne "%f %K{red} "
	    else
	    	echo -ne "%F{black} %K{cyan} "
	    fi
	fi
}

prompt_purity_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	local prompt_purity_preprompt="%c$(git_prompt_info) $(git_prompt_status)"

	# displays the exec time of the last command if set threshold was exceeded
	local stop=$EPOCHSECONDS
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${PURITY_CMD_MAX_EXEC_TIME:=5})) && print -P ' %F{yellow}`prompt_purity_human_time $elapsed`%f'

	# check async if there is anything to pull
	(( ${PURITY_GIT_PULL:-1} )) && {
		# check if we're in a git repo
		command git rev-parse --is-inside-work-tree &>/dev/null &&
		# check check if there is anything to pull
		command git fetch &>/dev/null &&
		# check if there is an upstream configured for this branch
		command git rev-parse --abbrev-ref @'{u}' &>/dev/null &&
		(( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) &&
		# some crazy ansi magic to inject the symbol into the previous line
		print -Pn "\e7\e[0G\e[`prompt_purity_string_length $prompt_purity_preprompt`C%F{cyan}⇣%f\e8"
	} &!

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}


prompt_purity_setup() {
	# prevent percentage showing up0
	# if output doesn't end with a newline
	export PROMPT_EOL_MARK=''

	prompt_opts=(cr subst percent)

	zmodload zsh/datetime
	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	add-zsh-hook precmd prompt_purity_precmd
	add-zsh-hook preexec prompt_purity_preexec

	# show username@host if logged in through SSH
	[[ "$SSH_CONNECTION" != '' ]] && prompt_purity_username='%n@%m '

	ZSH_THEME_GIT_PROMPT_PREFIX=""
	ZSH_THEME_GIT_PROMPT_SUFFIX=" %f%k%b"
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""

	# $(git_prompt_status)
	ZSH_THEME_GIT_PROMPT_ADDED="%F{green}✓%f "
	ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}✶%f "
	ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✗%f "
	ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}➜%f "
	ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}═%f "
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan}✩%f "

	# prompt turns red if the previous command didn't exit with 0
	PROMPT='%F{blue}$(prompt_purity_collapsed_wd) %(?.%F{green}.%F{red})❯%f '
	RPROMPT='$(git_prompt_status) $(prompt_purity_git_dirty)$(git_prompt_info)'
}

prompt_purity_setup "$@"
