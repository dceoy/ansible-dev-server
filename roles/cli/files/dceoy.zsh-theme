#!/usr/bin/env zsh

if [[ -n "${SSH_CONNECTION}" ]]; then
  local connection_color='magenta'
else
  local connection_color='cyan'
fi

local prompt_symbol='%(!.#.$)'
local datetime_colored="%{$fg_bold[blue]%}[%D{%Y-%m-%d} %D{%H:%M:%S}]%{$reset_color%}"
local prompt_symbol_colored="%(?::%B)%{$fg[${connection_color}]%}${prompt_symbol}%{$reset_color%}"
local cwd='[%n@%m:%~]'
local cwd_colored="%(?::%B)%{$fg[${connection_color}]%}${cwd}%{$reset_color%}"

PROMPT="${datetime_colored} ${prompt_symbol_colored} "
RPROMPT="\$(git_prompt_info) ${cwd_colored}"

ZSH_THEME_GIT_PROMPT_PREFIX="%(?::%B)%{$fg[${connection_color}]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}✗"
