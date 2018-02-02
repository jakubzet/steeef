# vim:et sts=2 sw=2 ft=zsh
#
# A customized version of the steeef theme from
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme
#
# Requires the `git-info` zmodule to be included in the .zimrc file.

prompt_steeef_help () {
  cat <<EOH
This is a customized steeef theme. Setting custom colors is disabled for sake
of extending the default terminal theme. NodeJS (NVM) version currently used
is displayed, as well as current time and left-hand side decorations.

EOH
}

prompt_steeef_git() {
  [[ -n ${git_info} ]] && print -n " ${(e)git_info[prompt]}"
}

prompt_steeef_nodejs() {
  local nvm_prompt
  if type nvm >/dev/null 2>&1; then
    nvm_prompt=$(nvm current 2>/dev/null)
    [[ "${nvm_prompt}x" == "x" ]] && return
  elif type node >/dev/null 2>&1; then
    nvm_prompt="$(node --version)"
  else
    return
  fi
  print "%F{green}\u2B21 %{$fg[red]%}${nvm_prompt}%f"
}

prompt_steeef_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] && print -n " (%F{blue}${VIRTUAL_ENV:t}%f)"
}

prompt_steeef_precmd() {
  (( ${+functions[git-info]} )) && git-info
}

prompt_steeef_setup() {
  [[ -n ${VIRTUAL_ENV} ]] && export VIRTUAL_ENV_DISABLE_PROMPT=1

  local col_user="%F{${1:-magenta}}"
  local col_host="%F{${2:-yellow}}"
  local col_pwd="%F{${3:-green}}"
  local col_brnch="%F{${4:-cyan}}"
  local col_unidx="%F{${5:-yellow}}"
  local col_idx="%F{${7:-green}}"
  local col_untrk="%F{${9:-red}}"
  local ind_unidx=${6:-●}
  local ind_idx=${8:-●}
  local ind_untrk=${10:-●}
  local col_stash=${11:+%F{${11}}}
  local ind_stash=${12}

  autoload -Uz add-zsh-hook && add-zsh-hook precmd prompt_steeef_precmd

  prompt_opts=(cr percent sp subst)

  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format "(${col_idx}%s%f)"
  zstyle ':zim:git-info:unindexed' format "${col_unidx}${ind_unidx}"
  zstyle ':zim:git-info:indexed' format "${col_idx}${ind_idx}"
  zstyle ':zim:git-info:untracked' format "${col_untrk}${ind_untrk}"
  zstyle ':zim:git-info:stashed' format "${col_stash}${ind_stash}"
  zstyle ':zim:git-info:keys' format \
    'prompt' "(${col_brnch}%b%c%I%i%u%f%S%f)%s"

  PS1="
┌ ${col_user}%n%f@${col_host}%m%f with $(prompt_steeef_nodejs) in ${col_pwd}%~%f\$(prompt_steeef_git)\$(prompt_steeef_virtualenv)
└ %(!.#.$) "
  RPS1='$(date +%H:%M:%S)'
}

prompt_steeef_preview () {
  if (( ${#} )); then
    prompt_preview_theme steeef "${@}"
  else
    prompt_preview_theme steeef
    print
    prompt_preview_theme steeef magenta yellow green cyan magenta '!' green '+' red '?' yellow '$'
  fi
}

prompt_steeef_setup "${@}"
