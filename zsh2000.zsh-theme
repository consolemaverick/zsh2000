CURRENT_BG='NONE'
SEGMENT_SEPARATOR_RIGHT='\ue0b2'
SEGMENT_SEPARATOR_LEFT='\ue0b0'

prompt_segment() {
  local bg fg seperator
  [[ -n $4 ]] && seperator=$1 || seperator=$SEGMENT_SEPARATOR_LEFT
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$seperator%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  local seperator
  [[ -n $1 ]] && seperator=$1 || seperator=$SEGMENT_SEPARATOR_LEFT
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$seperator"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$ZSH_2000_DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment magenta black
    else
      prompt_segment green white
    fi
    #echo -n "${ref/refs\/heads\//⭠ }$dirty"
    echo -n "${ref/refs\/heads\//}$dirty"
    
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment yellow black '%~'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_time() {
  prompt_segment white black '%D{%H:%M:%S}'
}

prompt_rvm() {
  prompt_segment yellow black `rvm-prompt` $SEGMENT_SEPARATOR_RIGHT
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

build_rprompt() {
  prompt_rvm
  prompt_time 
  prompt_end $SEGMENT_SEPARATOR_RIGHT
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='%{%f%b%k%}$(build_rprompt)'
