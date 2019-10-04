function git_prompt_info() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null || pwd | sed -e "s,$HOME,~,"
}
PROMPT="%{$fg_bold[magenta]%}%m%{$reset_color%} %{$fg_bold[white]%}$(git_prompt_info)%{$reset_color%}%# "

#ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
